defmodule ChatWeb.Router do
  use ChatWeb, :router

  # Define el pipeline `:api` para aceptar solo JSON.
  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/api", ChatWeb do
    pipe_through :api
    resources "/users", UserController, only: [:create, :show]
  end
end
