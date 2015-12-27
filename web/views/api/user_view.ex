defmodule Blog.API.UserView do
  use Blog.Web, :view

  @attributes ~w(id first_name last_name email)a

  def render("show.json", %{user: user}) do
    render_one(%{user: user})
  end

  def render_one(%{user: user}) do
    user
    |> Map.take(@attributes) # Filter the attributes we want to expose
  end
end
