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
      |> Enum.with_index(1)
      |> Enum.reduce(%{}, fn {round, number}, acc -> Map.put(acc, number, round) end)

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
    get_current_question(game)
  end

  @doc """
  Advances the game to the next question or series of questions. If no questions
  remain, checks for a winner.
  """
  def advance(game) do
    game.questions[game.current_round]
    |> increment_question_or_round(game)
  end

  def update_scores(game, team, points) do
    scores = update_in(game.scores[team], fn score -> score + points end)
    %Game{game | scores: scores}
  end

  @doc """
  Marks a question as answered by a team, along with their answer so that it may
  be reviewed later in the game.
  """
  def submit_answer(game, team, answer) do
    question = get_current_question(game)

    case question.answers[team] do
      res when is_binary(res) ->
        {:error, :answer_exists}

      _ ->
        Map.new()
        |> Map.put(team, answer)
        |> Map.merge(question.answers)
        |> Map.merge(question)
        |> mark_answer(game)
    end
  end

  defp increment_question_or_round(round, game) do
    next_question = game.current_question + 1

    if length(round) < next_question do
      %Game{game | current_round: game.current_round + 1, current_question: 1}
    else
      %Game{game | current_question: next_question}
    end
  end

  defp mark_answer(answered_question, game) do
    game =
      game
      |> Map.update!(:questions, fn rounds ->
        Enum.map(rounds, fn round ->
          Enum.map(round, fn question ->
            case question.id == answered_question.id do
              true -> answered_question
              false -> question
            end
          end)
        end)
      end)

    {:ok, game}
  end

  defp get_current_question(game) do
    Enum.at(game.questions[game.current_round], game.current_question)
  end
end
