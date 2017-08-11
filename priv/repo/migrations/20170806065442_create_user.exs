defmodule OhalaClassifieds.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :is_admin, :boolean, default: false, null: false
      add :name, :string
      add :id_no, :string
      add :email, :string
      add :is_active, :boolean, default: false, null: false
      add :encrypted_password, :string

      timestamps()
    end

  end
end
