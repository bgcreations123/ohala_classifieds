defmodule OhalaClassifieds.Ads do
  use OhalaClassifieds.Web, :model

  schema "ads" do
    field :title, :string
    field :body, :string
    field :approved, :boolean
    belongs_to :user, OhalaClassifieds.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :approved])
    |> validate_required([:title, :description])
  end
end
