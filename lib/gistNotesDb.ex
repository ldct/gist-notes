defmodule GistNotes.Db do
	def init() do
		Sqlitex.with_db('./db.sqlite3', fn(db) ->
			Sqlitex.query(db, "create table if not exists gists(id TEXT, description TEXT, content TEXT);")
		end)
	end
	def search(q) do
		{:ok, results} = Sqlitex.with_db('./db.sqlite3', fn(db) ->
			Sqlitex.query(db, "select id, substr(content,0,100) as trunc_content from gists where content like $1;", bind: ["%" <> q <> "%"])
		end)

		results
		|> Enum.map(fn row ->
			[id: id, trunc_content: trunc_content] = row
			%{
				"id" => id,
				"trunc_content" => trunc_content,
			}
		end)
	end
	def update() do

		api_key = File.read!("GITHUB_TOKEN")
		|> String.slice(0..-2)

		# pull from github api. todo: move out
		url = "https://api.github.com/users/zodiac/gists"
		(HTTPotion.get url, [
			basic_auth: {"zodiac", api_key},
			headers: ["User-Agent": "Gist-Notes-App"]
		]).body
		|> Poison.decode!
		|> Enum.map(fn gist ->
			%{
				"id" => id,
				"description" => description,
				"files" => files,
			} = gist

			files = files |> Map.values

			# filenames = files
			# |> Enum.map(fn file -> file |> Map.fetch!("filename") end)

			content = files
			|> Enum.map(fn file ->
				raw_url = file |> Map.fetch!("raw_url")
				(HTTPotion.get raw_url, [
					basic_auth: {"zodiac", api_key},
					headers: ["User-Agent": "Gist-Notes-App"]
				]).body
			end)

			Sqlitex.with_db('./db.sqlite3', fn(db) ->
				Sqlitex.query(db, "insert into gists(id, description, content) values($1, $2, $3);",
					bind: [id, description, content])
			end)

			# %{
			# 	"id" => id,
			# 	"description" => description,
			# 	"filenames" => filenames,
			# 	"content" => content,
			# }

		end)
	end
end