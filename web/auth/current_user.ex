defmodule OhalaClassifieds.CurrentUser do
  import Plug.Conn
  import Guardian.Plug

  alias OhalaClassifieds.Repo

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = current_resource(conn)
    |> Repo.preload(:roles)

    assign(conn, :current_user, current_user)
  end

end