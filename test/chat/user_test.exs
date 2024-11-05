defmodule Chat.UserTest do
  use Chat.DataCase, async: true
  use ExUnit.Case, async: true

  describe "users" do
    alias Chat.User

    @valid_attrs %{name: "testname", email: "test@mail.com", phone: "testphone"}
    @invalid_attrs %{name: "", email: "testmail"}

    test "create_user with valid data" do
      assert {:ok, %User{} = user} = User.create_user(@valid_attrs)

      assert user.id == 1
      assert user.name == "testname"
      assert user.email == "test@mail.com"
      assert user.phone == "testphone"
      assert user.role == "guest"
    end

    test "create_user with invalid data" do
      assert {:error, %Ecto.Changeset{} = user}
      = User.create_user(@invalid_attrs)

      assert %{email: ["must be a valid email"]} = errors_on(user)

      assert %{name: ["the name is required"]} = errors_on(user)

    end



    test "get users" do
      {:ok, user1} = User.create_user(%{name: "test User 1"})
    {:ok, user2} = User.create_user(%{name: "test User 2"})

    users = User.get_users()
    assert is_list(users)
    assert user1 in users
    assert user2 in users
    end
  end
end
