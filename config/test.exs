use Mix.Config

# Configure your database
config :gym_track, GymTrack.Repo,
  username: "postgres",
  password: "postgres",
  database: "gym_track_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :gym_track, GymTrackWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Make bcrypt faster during test runs
config :bcrypt_elixir, :log_rounds, 4
