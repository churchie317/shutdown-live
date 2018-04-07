defmodule Shutdown.Questions do
  @doc """
  Reads a CSV file of questions and their respective categories and values,
  converting them into Shutdown questions.
  """
  def read() do
    Application.get_env(:shutdown, :questions_path)
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn [question, category, points] ->
      %{question: question, category: category, points: points}
    end)
  end
end
