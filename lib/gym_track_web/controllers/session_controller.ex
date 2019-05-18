defmodule GymTrackWeb.SessionController do
  use GymTrackWeb, :controller

  alias GymTrack.Sessions
  alias GymTrack.Sessions.Session

  def new(conn, _params) do
    changeset = Sessions.change_session(%Session{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"session" => session_params}) do
    case Sessions.create_session(session_params) do
      {:ok, session} ->
        case Sessions.authenticate(session) do
          {:ok, user} ->
            conn
            |> put_session(:current_user_id, user.id)
            |> put_flash(:info, "User #{user.email} signed in successfully.")
            |> redirect(to: Routes.page_path(conn, :index))

          {:error, _} ->
            conn
            |> put_flash(:error, "Invalid email address or password.")
            |> render("new.html", changeset: Sessions.change_session(session))
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        render(conn, "new.html", changeset: changeset)
    end
  end
end
