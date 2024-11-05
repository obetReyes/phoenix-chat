defmodule ChatWeb.RoomChannel do
  use ChatWeb, :channel

  @impl true
  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def join("rooms:admin", _params, socket) do
    {:ok, socket}
  end

  # Escuchar cuando una sala se crea
  def handle_info(%{event: "room_created", payload: payload}, socket) do
    push(socket, "room_created", payload)
    {:noreply, socket}
  end

  def join("room:" <> room_id, _params, socket) do
    {:ok, assign(socket, :room_id, room_id)}
  end

  # Maneja los mensajes enviados en la sala
  #
  #def handle_in("message", %{"body" => body}, socket) do
    # Solo transmite a la sala actual
  #  broadcast!(socket, "message", %{"body" => body, "user" => socket.assigns.user_id})
  #  {:noreply, socket}
  #end

  @impl true
  def handle_info(:after_join, socket) do
    Chat.Message.get_messages()
    # revers to display the latest message at the bottom of the page
    |> Enum.reverse()
    |> Enum.each(fn msg ->
      push(socket, "shout", %{
        name: msg.name,
        message: msg.message,
        inserted_at: msg.inserted_at
      })
    end)

    # :noreply
    {:noreply, socket}
  end

  @impl true
  def handle_in("message", %{"body" => body}, socket) do
    room_id = socket.assigns[:room_id]
    broadcast!(socket, "message", %{body: body, room_id: room_id})
    {:noreply, socket}
  end
  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("shout", payload, socket) do
    Chat.Message.changeset(%Chat.Message{}, payload) |> Chat.Repo.insert()
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end



  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
