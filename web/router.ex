defmodule Blog.Router do
  use Blog.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
  end

  scope "/api", Blog, as: :api do
    pipe_through [:api, :browser_session]

    resources "/comments", API.CommentController
  end

  scope "/", Blog do
    pipe_through [:browser, :browser_session]

    get "/", PageController, :index

    resources "/users", UserController
    get "/comments", CommentController, :index

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
  end
end
