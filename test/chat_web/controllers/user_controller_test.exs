defmodule ChatWeb.UserControllerTest do
  use ChatWeb.ConnCase, async: true
  alias Chat.User
  alias Chat.Room
  alias ChatWeb.Router.Helpers, as: Routes

  @valid_user_params %{name: "Test User", email: "test@example.com", phone: "1234567890"}
  @invalid_user_params %{email: "invalid_email"}

  describe "POST /users (create)" do
    test "creates a user and room with valid data", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @valid_user_params)

      assert json_response(conn, 201)["user"]["name"] == "Test User"
      assert Map.has_key?(json_response(conn, 201), "room_id")
      assert get_session(conn, :username) == "Test User"
    end

    test "returns errors with invalid data", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_user_params)

      assert json_response(conn, 422)["error"] != nil
      assert %{"name" => _} = json_response(conn, 422)["error"]["errors"]
    end
  end

  describe "GET /users (show)" do
    test "shows the current user's name in the session", %{conn: conn} do
      conn = conn |> fetch_session() |> put_session(:username, "Test User")
      conn = get(conn, Routes.user_path(conn, :show))

      assert json_response(conn, 200)["user"] == "Test User"
    end
  end
end
