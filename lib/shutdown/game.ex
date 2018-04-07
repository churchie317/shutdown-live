defmodule Shutdown.Game do
  @enforce_keys [:questions]
  defstruct round: 1, scores: %{}, winner: nil, questions: nil

  def new(questions, rounds) when is_list(questions) do
    round_size = div(length(questions), rounds)

    questions =
      questions
      |> Enum.chunk_every(round_size)

    %Shutdown.Game{questions: questions}
  end

  def update_scores(game, team, points) do
    scores =
      game.scores
      |> Map.update!(team, fn score -> score + points end)

    %{game | scores: scores}
  end

  def answer(game, team, answer) do
    game = game
    team = team
    answer = answer
  end
end
