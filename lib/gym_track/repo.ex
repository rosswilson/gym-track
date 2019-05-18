defmodule GymTrack.Repo do
  use Ecto.Repo,
    otp_app: :gym_track,
    adapter: Ecto.Adapters.Postgres
end
