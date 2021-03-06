defmodule GymTrackWeb.Router do
  use GymTrackWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GymTrackWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources "/exercises", ExerciseController

    get "/register", RegisterController, :new
    post "/register", RegisterController, :create

    get "/signin", SessionController, :new
    post "/signin", SessionController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", GymTrackWeb do
  #   pipe_through :api
  # end
end
