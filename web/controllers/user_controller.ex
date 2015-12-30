defmodule Blog.UserController do
  use Blog.Web, :controller

  alias Blog.User

  plug :scrub_params, "user" when action in [:create, :update]

  plug :load_and_authorize_resource, model: User
  plug :redirect_if_unauthorized

  def index(conn, _params) do
    render(conn, "index.html")
  end
def new(conn, _params) do
    changeset = User.create_changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.create_changeset(%User{}, user_params)

    # trying to insert an invalid changeset will result in an error return value
    # with errors listed in changeset.errors , so we can just read the errors in the template
    # if there are any
    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.html")
  end

  def edit(conn, %{"id" => id}) do
    changeset = User.update_changeset(conn.assigns.user)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    changeset = User.update_changeset(conn.assigns.user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(conn.assigns.user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end

  def redirect_if_unauthorized(conn = %Plug.Conn{assigns: %{authorized: false} }, _opts) do
    conn
    |> put_flash(:error, "You can't access that page!")
    |> redirect(to: "/")
    |> halt
  end

  def redirect_if_unauthorized(conn = %Plug.Conn{assigns: %{authorized: true} }, _opts), do: conn
end
