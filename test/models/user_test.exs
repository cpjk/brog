defmodule Blog.UserTest do
  use Blog.ModelCase

  alias Blog.User
  alias Blog.Repo

  @valid_attrs %{first_name: "some content",
    last_name: "some content",
    email: "person@example.com",
    password: "password"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.create_changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "create user with email that is already taken fails" do
    changeset = User.create_changeset(%User{}, @valid_attrs)
    Repo.insert! changeset
    duplicate_changeset = User.create_changeset(%User{}, @valid_attrs)

    assert_raise Ecto.InvalidChangesetError, fn ->
      Repo.insert! duplicate_changeset
    end
  end

  test "changeset with invalid attributes" do
    changeset = User.create_changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "create user with password stores encrypted password" do
    changeset = User.create_changeset(%User{}, @valid_attrs)
    Repo.insert! changeset
    stored_user = Repo.one(User)
    assert Comeonin.Bcrypt.checkpw(@valid_attrs.password, stored_user.encrypted_password)
  end
end
