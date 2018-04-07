defmodule Shutdown.Question do
  @enforce_keys [:category, :points, :question]
  defstruct answered: MapSet.new(), category: nil, points: nil, question: nil

  alias __MODULE__

  @doc """
  Creates a new question given a category, a points value for the question, and question string.
  """
  def new(question, category, points \\ 1) do
    %Question{category: category, points: points, question: question}
  end
end
