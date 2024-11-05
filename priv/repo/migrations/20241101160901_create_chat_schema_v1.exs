defmodule Chat.Repo.Migrations.CreateChatSchemaV1 do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string
      add :phone, :string
      add :role, :string, default: "guest"
      timestamps()
    end


    alter table(:messages) do
      remove :name
      add :user_id, references(:users)
    end
  end

end
