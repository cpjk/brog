defmodule Blog.API.CommentView do
  use Blog.Web, :view

  @attributes ~w(id text user)a

  def render("index.json", %{comments: comments}) do
    %{comments: render_many(%{comments: comments})}
  end

  def render("show.json", %{comment: comment}) do
    %{comment: render_one(%{comment: comment})}
  end

  def render_many(%{comments: comments}) do
    comments
    |> Enum.map(fn comment ->
      render_one(%{comment: comment})
    end)
  end

  def render_one(%{comment: comment}) do
    comment
    |> Map.take(@attributes) # Filter the attributes we want to expose
    |> Map.put(:user, Blog.API.UserView.render("show.json", user: comment.user))
  end
end
