defmodule Blog.UserController do
  use Blog.Web, :controller

  alias Blog.User

  plug :scrub_params, "user" when action in [:create, :update]

  plug :load_and_authorize_resource, model: User
  plug :handle_not_found

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

  defp handle_not_found(conn = %Plug.Conn{private: %{phoenix_action: action}}, _opts)
    when action in [:new, :create], do: conn

  defp handle_not_found(conn = %Plug.Conn{assigns: %{user: nil}}, _opts) do
    conn |> Blog.ControllerHelpers.redirect_on_not_found
  end

  defp handle_not_found(conn, _opts), do: conn

end
