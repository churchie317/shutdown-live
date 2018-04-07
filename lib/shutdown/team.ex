defmodule Shutdown.Team do
  @enforce_keys [:color, :name]
  defstruct color: nil, name: nil

  alias __MODULE__

  def new(name, color) do
    %Team{color: color, name: name}
  end
end
