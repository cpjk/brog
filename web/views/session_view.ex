defmodule Blog.SessionView do
  use Blog.Web, :view

  def has_errors?(changeset = %Ecto.Changeset{}) do
    !Enum.empty? changeset.errors
  end
end
