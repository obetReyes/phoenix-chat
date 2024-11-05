defmodule ChatWeb.ErrorHandler do
  import Plug.Conn
  use Plug.ErrorHandler

  # Define la función call/2 necesaria para usar Plug.ErrorHandler.
  def init(opts), do: opts

  # Define la función call/2.
  def call(conn, _opts) do
    # Aquí puedes continuar con la conexión sin llamar a `super`.
    conn
  end

  # Define qué hacer en caso de error.
  @impl true
  def handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    IO.inspect({kind, reason, stack}, label: "Error capturado")

    conn
    |> put_status(:internal_server_error)
    |> put_resp_content_type("application/json")
    |> send_resp(500, Jason.encode!(%{error: "Ha ocurrido un error inesperado"}))
  end


end
