defmodule Blog.CommentTest do
  use Blog.ModelCase

  alias Blog.Comment

  @valid_attrs %{text: "asd", user_id: 4}
  @invalid_attrs %{text: 1, user_id: 4}

  test "changeset with valid attributes" do
    changeset = Comment.create_changeset(%Comment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Comment.create_changeset(%Comment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
