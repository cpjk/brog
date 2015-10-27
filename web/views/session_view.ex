defmodule Blog.SessionView do
  use Blog.Web, :view

  def has_errors?(changeset = %Ecto.Changeset{}) do
    !Enum.empty? changeset.errors
  end

  def poop_emoji do
    Exmoji.find_by_short_name("poop")
    |> Enum.at(0)
    |> Exmoji.EmojiChar.render
  end

  def thumbs_down do
    Exmoji.find_by_short_name("-1")
    |> Enum.at(0)
    |> Exmoji.EmojiChar.render
  end
end
