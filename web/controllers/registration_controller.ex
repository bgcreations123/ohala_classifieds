defmodule OhalaClassifieds.RegistrationController do
  use OhalaClassifieds.Web, :controller

  alias OhalaClassifieds.Repo
  alias OhalaClassifieds.User
  alias OhalaClassifieds.Role
  alias OhalaClassifieds.UserRoles

  def new(conn, _) do
    changeset = User.new()
    render conn, :new, changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    role = Repo.get_by(Role, name: "default")

    changeset = %User{}
    |> User.changeset(user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        #insert the user and role in user_roles
        Repo.insert(%UserRoles{:user_id => user.id, :role_id => role.id})

        conn
        |> OhalaClassifieds.Auth.login(user)
        |> put_flash(:success, "#{user.email} created!")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

end