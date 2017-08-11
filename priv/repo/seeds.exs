# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Eecrit.Repo.insert!(%Eecrit.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias OhalaClassifieds.Role
alias OhalaClassifieds.User
alias Ecto.Changeset
alias OhalaClassifieds.Repo

defmodule U do
  def fresh_start!() do
  end

  def add_user!(user) do
    %User{}
    |> User.changeset(as_map(user))
    |> Repo.insert!
  end

  def add_role!(role) do
    struct(Role, as_map(role))
    |> Repo.insert!
  end

  defp as_map(map), do: Enum.into(map, %{})
end


# Roles
Repo.delete_all(Role)
U.add_role! name: "backend",
            description: "Strongest of the users, Super Admin of Admins"

U.add_role! name: "admin",
            description: "Site Administrator"

U.add_role! name: "default",
            description: "Normal user"

# Users
Repo.delete_all(User)
U.add_user! name: "Backend User",
            email: "backend@test.com",
            is_admin: true,
            is_active: true,
            password: "backend_password",
            password_confirmation: "backend_password"


# Relationships
role = Repo.get_by(Role, name: "backend") |> Repo.preload(:users)

for u <- Repo.all(User) do
  u
  |> Repo.preload(:roles)
  |> Changeset.change
  |> Changeset.put_assoc(:roles, [role])
  |> Repo.update!
end