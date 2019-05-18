defmodule GymTrackWeb.ExerciseController do
  use GymTrackWeb, :controller

  alias GymTrack.Exercises
  alias GymTrack.Exercises.Exercise

  def index(conn, _params) do
    exercises = Exercises.list_exercises()
    render(conn, "index.html", exercises: exercises)
  end

  def new(conn, _params) do
    changeset = Exercises.change_exercise(%Exercise{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"exercise" => exercise_params}) do
    case Exercises.create_exercise(exercise_params) do
      {:ok, exercise} ->
        conn
        |> put_flash(:info, "Exercise created successfully.")
        |> redirect(to: Routes.exercise_path(conn, :show, exercise))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    exercise = Exercises.get_exercise!(id)
    render(conn, "show.html", exercise: exercise)
  end

  def edit(conn, %{"id" => id}) do
    exercise = Exercises.get_exercise!(id)
    changeset = Exercises.change_exercise(exercise)
    render(conn, "edit.html", exercise: exercise, changeset: changeset)
  end

  def update(conn, %{"id" => id, "exercise" => exercise_params}) do
    exercise = Exercises.get_exercise!(id)

    case Exercises.update_exercise(exercise, exercise_params) do
      {:ok, exercise} ->
        conn
        |> put_flash(:info, "Exercise updated successfully.")
        |> redirect(to: Routes.exercise_path(conn, :show, exercise))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", exercise: exercise, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    exercise = Exercises.get_exercise!(id)
    {:ok, _exercise} = Exercises.delete_exercise(exercise)

    conn
    |> put_flash(:info, "Exercise deleted successfully.")
    |> redirect(to: Routes.exercise_path(conn, :index))
  end
end
