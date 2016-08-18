ExUnit.start
ExUnit.configure(timeout: 600_000)

# create a new session for the given user
defmodule TestHelpers do
  use Blog.ConnCase

  # login the user through the SessionController
  def login_user(conn, params = %{email: _email, password: _password}) do
    post conn, session_path(conn, :create), user: params
  end

  # create a new user with given attrs
  def create_user(attrs) do
    changeset = Blog.User.create_changeset(%Blog.User{}, attrs)
    Blog.Repo.insert! changeset
  end
end

Ecto.Adapters.SQL.Sandbox.mode(Blog.Repo, :manual)
