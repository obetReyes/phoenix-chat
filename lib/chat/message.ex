defmodule Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query # add Ecto.Query

  schema "messages" do
    field :message, :string
    belongs_to :user, Chat.User  # Relación con Chat.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:message, :user_id])
    |> validate_required([:message, :user_id])
  end


  def get_messages(limit \\ 20) do
    Chat.Message
    |> limit(^limit)
    |> order_by(desc: :inserted_at)
    |> Chat.Repo.all()
  end


  # Función para obtener los mensajes de un usuario con límite
  def get_messages_by_user(user_id, limit) do
    from(m in Chat.Message,
      where: m.user_id == ^user_id,
      order_by: [desc: m.inserted_at],
      limit: ^limit
    )
    |> Chat.Repo.all()
  end

end
