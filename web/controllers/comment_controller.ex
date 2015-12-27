defmodule Blog.CommentController do
  use Blog.Web, :controller

  alias Blog.Comment

  plug :scrub_params, "comment" when action in [:create, :update]

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
