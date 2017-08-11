defmodule OhalaClassifieds.Member.UserController do
  use OhalaClassifieds.Web, :controller

  alias OhalaClassifieds.User

  def index(conn, _params) do
    users = User
    |> Repo.all

    render(conn, "index.html", users: users)
  end

end