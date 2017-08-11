defmodule OhalaClassifieds.UserRoles do
  use OhalaClassifieds.Web, :model

  schema "user_roles" do
    belongs_to :user, OhalaClassifieds.User
    belongs_to :role, OhalaClassifieds.Role
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :role_id])
    |> validate_required([:user_id, :role_id])
  end
end
