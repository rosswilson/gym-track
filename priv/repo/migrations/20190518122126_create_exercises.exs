defmodule GymTrack.Repo.Migrations.CreateExercises do
  use Ecto.Migration

  def change do
    create table(:exercises) do
      add :name, :string
      add :description, :string

      timestamps()
    end
  end
end
