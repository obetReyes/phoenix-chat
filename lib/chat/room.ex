defmodule Chat.Room do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "rooms" do
    belongs_to :user, Chat.User

    timestamps(type: :utc_datetime)
  end


  def changeset(room, attrs) do
    room
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
  end

  def get_rooms() do
    Chat.Room
    |> order_by(desc: :updated_at)
    |> Chat.Repo.all()
  end


   def create_room(attrs) do
    case %Chat.Room{}
         |> changeset(attrs)
         |> Chat.Repo.insert() do
      {:ok, room} ->
        # Notificar al servidor que una nueva sala fue creada
        ChatWeb.Endpoint.broadcast!("rooms:admin", "room_created", %{room: room})
        {:ok, room}

      {:error, changeset} ->
        {:error, changeset}
    end
  end


   def get_room_by_user(user_id) do
    Chat.Room
    |> where(user_id: ^user_id)
    |> Chat.Repo.one()
   end


end
