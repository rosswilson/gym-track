defmodule GymTrack.Sessions do
  @moduledoc """
  The Sessions context.
  """

  import Ecto.Query, warn: false

  alias GymTrack.Sessions.Session

  alias GymTrack.Users

  @doc """
  Creates a session.

  ## Examples

      iex> create_session(%{field: value})
      {:ok, %Session{}}

      iex> create_session(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_session(attrs \\ %{}) do
    %Session{}
    |> Session.changeset(attrs)
    |> Session.validate()
  end

  def authenticate(%Session{email: email, password: password}) do
    Users.get_user_by_email(email)
    |> check_password(password)
  end

  defp check_password(user, password) do
    case Bcrypt.check_pass(user, password) do
      {:ok, user} -> {:ok, user}
      {:error, _} -> {:error, nil}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking session changes.

  ## Examples

      iex> change_session(session)
      %Ecto.Changeset{source: %Session{}}

  """
  def change_session(%Session{} = session) do
    Session.changeset(session, %{})
  end
end
