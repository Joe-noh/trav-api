defmodule Trav.Config do

  @config Application.get_env(:trav, :config)

  def get(key) do
    @config |> Keyword.get(key)
  end
end
