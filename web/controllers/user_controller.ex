defmodule OhalaClassifieds.UserController do
  use OhalaClassifieds.Web, :controller

  alias OhalaClassifieds.User
  alias OhalaClassifieds.Repo

  def show(conn, %{"id" => id}) do
    user = User
    |> Repo.get!(id)
    |> Repo.preload(:roles)

    render(conn, "show.html", user: user)
  end

end