defmodule OhalaClassifieds.Repo.Migrations.CreateAds do
  use Ecto.Migration

  def change do
    create table(:ads) do
      add :title, :string
      add :body, :text
      add :approved, :boolean, default: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:ads, [:user_id])

  end
end
