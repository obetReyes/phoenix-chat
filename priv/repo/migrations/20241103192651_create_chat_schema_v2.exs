defmodule Chat.Repo.Migrations.CreateChatSchemaV2 do
  use Ecto.Migration

  def change do
    create table (:rooms) do
      add :user_id, references(:users)
      timestamps()
    end
  end
end
