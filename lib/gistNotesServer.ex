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

    jsonResult = Poison.encode!(%{
      "hello" => "world"
    })
    conn
    |> put_resp_content_type("application/json; charset=UTF-8")
    |> put_resp_header("access-control-allow-origin", "*")
    |> send_resp(200, jsonResult)
  end

  get "/q/:qs" do

    jsonResult = GistNotes.Db.search(qs)
    |> Poison.encode!

    conn
    |> put_resp_content_type("application/json; charset=UTF-8")
    |> put_resp_header("access-control-allow-origin", "*")
    |> send_resp(200, jsonResult)
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end