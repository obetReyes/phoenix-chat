defmodule Chat.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @derive {Jason.Encoder, only: [:id, :name, :email, :phone, :role, :inserted_at, :updated_at]}
  schema "users" do
    field :name, :string
    field :email, :string
    field :phone, :string
    field :role, :string
    has_many :rooms, Chat.Room # Relación uno a muchos

    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :phone, :role])
    |> validate_required([:name], message: "the name is required")
    |> validate_format(:email, ~r/@/, message: "must be a valid email")
    |> put_change(:role, "guest") # Establece "guest" como valor por defecto si no se proporciona

  end

  def get_users(limit \\ 20) do
    Chat.User
    |> limit(^limit)
    |> order_by(desc: :inserted_at)
    |> Chat.Repo.all()
  end

  def create_user(attrs) do
    %Chat.User{}
    |> changeset(attrs)
    |> Chat.Repo.insert()
  end
end
