defmodule Chat.RoomTest do
  use Chat.DataCase, async: true
  use ExUnit.Case, async: true

  describe "rooms" do
    alias Chat.Room
    alias Chat.User

    @valid_attrs %{ user_id: 1}
    @update_attrs %{user_id: 4}
    @invalid_attrs %{user_id: "1a"}



    setup do

      {:ok, user} = Chat.Repo.insert(%User{name: "Test User"})
      {:ok, user} = Chat.Repo.insert(%User{name: "Test User 2"})

      # Actualiza los atributos válidos con el ID del usuario insertado
      valid_attrs = %{user_id: user.id}

      valid_attrs = Map.put(@valid_attrs, :user_id, user.id)
      {:ok, valid_attrs: valid_attrs}
    end

    # ...

    test "create_room with with valid data" do
      assert {:ok, %Room{} = room} = Room.create_room(@valid_attrs)
      assert room.user_id == 1
      assert room.inserted_at != nil
      assert room.updated_at != nil
    end

    test "create_room with with invalid data" do
      assert {:error, %Ecto.Changeset{} = room} = Room.create_room(@invalid_attrs)

    end


    test "get room by user with valid data" do
      {:ok, room} = Room.create_room(%{user_id: 1})
      assert Room.get_room_by_user(1) == room
   end



   test "get room by user with invalid data" do
      assert Room.get_room_by_user(1) == nil
  end

  test "get rooms" do
    {:ok, room1} = Room.create_room(%{user_id: 1})
    {:ok, room2} = Room.create_room(%{user_id: 2})
    rooms = Room.get_rooms()
    assert is_list(rooms)
    assert room1 in rooms
    assert room2 in rooms
  end

  end
end
