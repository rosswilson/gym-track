defmodule GymTrack.Sessions.Session do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :email, :string
    field :password, :string
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 12)
  end

  def validate(changeset), do: apply_action(changeset, :insert)
end
