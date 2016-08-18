defmodule Blog.SessionController do
  use Blog.Web, :controller

  alias Blog.User

  plug :scrub_params, "user" when action in [:create]

  def new(conn, _params) do
    changeset = User.new_session_changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params = %{}) do
    changeset = User.create_session_changeset(params["user"])

    case changeset.valid? do
      true ->
        conn
        |> put_flash(:info, "Logged in")
        |> Guardian.Plug.sign_in(changeset.data, :token)
        |> redirect(to: page_path(conn, :index))
      _    ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    Guardian.Plug.sign_out(conn)
    |> put_flash(:info, "Logged out successfully.")
    |> redirect(to: "/")
  end
end
