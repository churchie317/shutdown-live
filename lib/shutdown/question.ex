defmodule Shutdown.Question do
  @enforce_keys [:category, :points, :question]
  defstruct answers: %{}, category: nil, id: nil, points: nil, question: nil

  alias __MODULE__

  @doc """
  Creates a new question given a category, a points value for the question, and question string.
  """
  def new(question, category, points \\ 1) do
    %Question{category: category, points: points, question: question}
  end

  @doc """
  """
  def new(%{question: question, category: category} = q) do
    %Question{category: category, points: q[:points] || 1, question: question}
  end
end
