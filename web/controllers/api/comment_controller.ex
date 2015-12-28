defmodule Blog.API.CommentController do
  use Blog.Web, :controller

  alias Blog.Comment

  plug :scrub_params, "comment" when action in [:create, :update]

  def index(conn, _params) do
    comments = Repo.all(Comment) |> Blog.Repo.preload(:user)

    render(conn, Blog.API.CommentView, "index.json", comments: comments)
  end

  def create(conn, %{"comment" => comment_params}) do
    # associate the comment with the current user
    comment = Ecto.build_assoc(current_user(conn), :comments)
    changeset = Comment.create_changeset(comment, comment_params)
    IEx.pry

    case Repo.insert(changeset) do
      {:ok, comment} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", comment_path(conn, :index))
        |> render(Blog.CommentView, "index.html")
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Blog.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Repo.get!(Comment, id) |> Blog.Repo.preload(:user)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Repo.get!(Comment, id)
    changeset = Comment.changeset(comment, comment_params)

    case Repo.update(changeset) do
      {:ok, comment} ->
        render(conn, "show.json", data: comment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Blog.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Repo.get!(Comment, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(comment)

    send_resp(conn, :no_content, "")

  end

  defp current_user(conn) do
    conn.assigns.guardian_default_resource
  end

  defp comments_with_users() do
    comments = Repo.all(Comment) |> Blog.Repo.preload(:user)
  end
end
