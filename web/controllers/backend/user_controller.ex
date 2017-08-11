defmodule OhalaClassifieds.Backend.UserController do
  use OhalaClassifieds.Web, :controller

  alias OhalaClassifieds.User
  alias OhalaClassifieds.Role
  alias OhalaClassifieds.UserRoles

  def index(conn, _params) do
    users = User
    |> Repo.all()

    render(conn, "index.html", users: users)
  end

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
        |> put_flash(:success, "#{user.email} created!")
        |> redirect(to: backend_user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = User
    |> Repo.get!(id)
    |> Repo.preload(:roles)

    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = User
    |> Repo.get!(id)

    if user do
      changeset = User.changeset(user)
      render(conn, "edit.html", user: user, changeset: changeset)
    else
      conn
      |> put_status(:not_found)
      |> render(AuthStudy.ErrorView, "404.html")
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = User
    |> Repo.get(id)

    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "User was updated successfully")
        |> redirect(to: backend_user_path(conn, :show, user.id))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    Repo.get!(User, id) |> Repo.delete!

    conn
    |> put_flash(:info, "User Deleted Successfully")
    |> redirect(to: backend_user_path(conn, :index))
  end

  def edit_user_role(conn, %{"user_id" => user_id, "role_id" => role_id}) do
    user_role = UserRoles
    |> Repo.get_by(user_id: user_id, role_id: role_id)

    roles = Role
    |>Repo.all

    if user_role do
      changeset = UserRoles.changeset(user_role)
      render(conn, "edit_user_role.html", user_id: user_id, role_id: role_id, roles: roles, changeset: changeset)
    else
      conn
      |> put_status(:not_found)
      |> render(OhalaClassifieds.ErrorView, "404.html")
    end
  end

  def update_user_role(conn, %{"user_id" => user_id, "role_id" => role_id, "user_roles" => user_roles_params}) do
    user_role = UserRoles
    |> Repo.get_by(user_id: user_id, role_id: role_id)

    roles = Role
    |>Repo.all

    changeset = UserRoles.changeset(user_role, user_roles_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Role was updated successfully")
        |> redirect(to: backend_user_path(conn, :show, user_id))
      {:error, changeset} ->
        render(conn, "edit_user_role.html", user_id: user_id, role_id: role_id, roles: roles, changeset: changeset)
    end
  end

  def trigger_action(conn, %{"user_id" => user_id}) do
    user = User
    |> Repo.get!(user_id)

    if user.is_active do
      from(u in User, where: u.id == ^user_id)
      |> Repo.update_all(set: [is_active: false])

      conn
      |> put_flash(:error, "User deactivated successfully...!")
      |> redirect(to: backend_user_path(conn, :index))
    else
      from(u in User, where: u.id == ^user_id)
      |> Repo.update_all(set: [is_active: true])

      conn
      |> put_flash(:success, "User Activated successfully...!")
      |> redirect(to: backend_user_path(conn, :index))
    end

  end

end