defmodule OhalaClassifieds.User do
  use OhalaClassifieds.Web, :model

  alias OhalaClassifieds.Repo

  schema "users" do
    field :is_admin, :boolean, default: false
    field :is_active, :boolean, default: false
    field :name, :string
    field :first_name, :string, virtual: true
    field :last_name, :string, virtual: true
    field :id_no, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :encrypted_password, :string

    has_many :ads, OhalaClassifieds.Ads

    many_to_many :roles, OhalaClassifieds.Role, join_through: "user_roles"

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:is_admin, :is_active, :name, :email, :password, :password_confirmation, :encrypted_password])
    |> validate_required([:email, :password, :password_confirmation])
    # |> full_name()
    |> validate_confirmation(:password, message: "Passwords dont match!")
    |> encrypted_password()
  end

  def new() do
    cast(%__MODULE__{}, %{}, [])
  end

#  def full_name(changeset) do
#    first_name = get_change(changeset, :first_name) || ""
#    last_name = get_change(changeset, :last_name) || ""
#    full_name = first_name <> " " <> last_name
#    put_change(changeset, :name, full_name)
#  end

  def encrypted_password(changeset) do
    password = get_change(changeset, :password) || ""
    encrypted_password = Comeonin.Bcrypt.hashpwsalt(password)
    put_change(changeset, :encrypted_password, encrypted_password)
  end

  def valid_authentication?(email, password) do
    case Repo.get_by(__MODULE__, email: email) do
      nil ->
        {Comeonin.Bcrypt.dummy_checkpw(), nil}
      user ->
        {Comeonin.Bcrypt.checkpw(password, user.encrypted_password), user}
    end
  end
end
