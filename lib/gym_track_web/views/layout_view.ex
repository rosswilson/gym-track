defmodule GymTrackWeb.LayoutView do
  use GymTrackWeb, :view

  def current_user(conn) do
    conn
    |> Plug.Conn.get_session(:current_user_id)
    |> fetch_user()
  end

  defp fetch_user(nil), do: nil
  defp fetch_user(user_id), do: GymTrack.Users.get_user(user_id)
end
