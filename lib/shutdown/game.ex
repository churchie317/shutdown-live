defmodule Shutdown.Game do
  @enforce_keys [:questions]
  defstruct current_question: 1,
            current_round: 1,
            questions: nil,
            scores: %{},
            started: false,
            winner: nil

  alias Shutdown.{Game, Question, Questions}

  @doc """
  Creates a game of Shutdown of questions chunked into the given number of rounds from a
  list of questions.
  """
  def new(questions, rounds) when is_list(questions) do
    round_size = div(length(questions), rounds)

    questions =
      questions
      |> Enum.map(&Question.new(&1))
      |> Enum.with_index(1)
      |> Enum.map(fn {question, index} -> %Question{question | id: index} end)
      |> Enum.chunk_every(round_size)

    %Game{questions: questions}
  end

  @doc """
  Creates a game of shutdown of rounds from a collection of questions.
  """
  def new(rounds \\ 1) do
    Questions.read()
    |> Enum.shuffle()
    |> Game.new(rounds)
  end

  @doc """
  Shows the current question of the given game.
  """
  def show(game) do
    game.questions
    |> Enum.at(game.current_round)
    |> Enum.at(game.current_question)
  end

  @doc """
  Advances the game to the next question or series of questions. If no questions
  remain, checks for a winner.
  """
  def advance(game) do
    game.questions
    |> Enum.at(game.current_round)
    |> increment_question_or_round(game)
  end

  def update_scores(game, team, points) do
    scores =
      game.scores
      |> Map.update!(team, fn score -> score + points end)

    %{game | scores: scores}
  end

  def answer(team, answer, game) do
    answer =
      get_current_question(game)

    game.questions
    |> List.flatten()
  end

  defp increment_question_or_round(round, game) do
    next_question = game.current_question + 1

    if length(round) < next_question do
      %Game{game | current_round: game.current_round + 1, current_question: 1}
    else
      %Game{game | current_question: next_question}
    end
  end

  defp get_current_question(game) do
    game.questions
    |> Enum.at(game.current_round)
    |> Enum.at(game.current_question)
  end
end
