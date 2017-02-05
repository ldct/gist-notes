defmodule GistNotes do
  use Application

  def start(_type, _args) do
    Plug.Adapters.Cowboy.http(GistNotesServer, [], port: getPort)
  end

  def getPort do
    4000
  end

end