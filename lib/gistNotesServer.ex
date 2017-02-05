defmodule GistNotesServer do

  use Plug.Router
  plug Plug.Parsers, parsers: [:json], json_decoder: Poison

  plug :match
  plug :dispatch

  get "/host" do
    conn |> IO.inspect
    send_resp(conn, 200, conn.host)
  end

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end