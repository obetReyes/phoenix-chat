defmodule ChatWeb.UserController do
  use ChatWeb, :controller
  alias Chat.User
  alias Chat.Room

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"user" => user_params}) do
    case User.create_user(user_params) do
      {:ok, user} ->
        {:ok, room} = Room.create_room(%{user_id: user.id})
        conn
        |> put_session(:username, user.name)
        |> put_status(:created)
        |> json(%{user: user, room_id: room.id})  # Incluir el ID de la sala en la respuesta

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: changeset})
    end
  end



  def show(conn, _params) do
    username = get_session(conn, :username)
    json(conn, %{user: username})
  end
end
