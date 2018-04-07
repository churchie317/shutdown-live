defmodule Shutdown.Question do
  @enforce_keys [:points, :question]
  defstruct answers: %{}, category: nil, id: nil, points: 1, question: nil

  alias __MODULE__

  @doc """
  Creates a new question given a map with key `:question`. Map may optionally contain `:category`
  and `:points` keys, but will default to values `nil` and 1, respectively when absent.
  """
  def new(question) when is_map(question) do
    %Question{
      category: question[:category],
      points: question[:points] || 1,
      question: question[:question]
    }
  end

  @doc """
  Creates a new question from an Elixir binary term. `points` defaults to value 1.
  """
  def new(question), do: %Question{points: 1, question: question}

  @doc """
  Creates a new question from Elixir binary terms representing a question and category. Points value
  optionally passed in (defaults to 1).
  """
  def new(question, category, points \\ 1) do
    %Question{category: category, points: points || 1, question: question}
  end
end
