defmodule OhalaClassifieds.Role do
  use OhalaClassifieds.Web, :model

  schema "roles" do
    field :name, :string
    field :description, :string

    many_to_many :users, OhalaClassifieds.User, join_through: "user_roles"

  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description])
    |> validate_required([:name, :description])
  end
end
