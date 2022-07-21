defmodule GraphQLApi.Plug do
  use Plug.Router

  plug Plug.SSL, rewrite_on: [:x_forwarded_host, :x_forwarded_port, :x_forwarded_proto]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
    pass: ["*/*"],
    json_decoder: Jason

  @schema GraphQLApi.Schema

  forward "/graphiql",
    to: Absinthe.Plug.GraphiQL,
    init_opts: [schema: @schema]

  forward "/api",
    to: Absinthe.Plug,
    init_opts: [schema: @schema]

  plug :match
  plug :dispatch


  match _ do
    send_resp(conn, 404, "")
  end
end
