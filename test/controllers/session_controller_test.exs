defmodule Blog.SessionControllerTest do
  use Blog.ConnCase

  alias Blog.User

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  @invalid_email "bad@horse.com"
  @invalid_password "hihosilver"

  @valid_email "ricksanchez@earth.com"
  @valid_password "rickytickytavy"

  @valid_user_attrs %{
    first_name: "some content",
    last_name: "some content",
    email: @valid_email,
    password: @valid_password
  }

  test "renders form for a new session", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "Login"
  end

  test "does not create a new session when email does not exist",
                                              %{conn: conn} do
    Repo.insert! User.create_changeset(%User{}, @valid_user_attrs)
    conn = post conn, session_path(conn, :create), user: %{
      email: @invalid_email, password: @invalid_password}
    assert html_response(conn, 200) =~ "Login"
    assert Guardian.Plug.current_resource(conn) == nil
  end

  test "does not create a new session when credentials do not match",
                                              %{conn: conn} do
    Repo.insert! User.create_changeset(%User{}, @valid_user_attrs)
    conn = post conn, session_path(conn, :create), user: %{
      email: @valid_email, password: @invalid_password}
    assert html_response(conn, 200) =~ "Login"
    assert Guardian.Plug.current_resource(conn) == nil
  end

  test "creates a new session and redirects when credentials are valid",
                                              %{conn: conn} do
    Repo.insert! User.create_changeset(%User{}, @valid_user_attrs)
    conn = post conn, session_path(conn, :create), user: %{
      email: @valid_email, password: @valid_password}
    assert redirected_to(conn) == page_path(conn, :index)
    assert %User{} = Guardian.Plug.current_resource(conn)
  end

  test "deletes the current session",
                                              %{conn: conn} do
    Repo.insert! User.create_changeset(%User{}, @valid_user_attrs)
    conn = post conn, session_path(conn, :create), user: %{
      email: @valid_email, password: @valid_password}

    assert %User{} = Guardian.Plug.current_resource(conn)

    conn = delete conn, session_path(conn, :delete)
    assert Guardian.Plug.current_resource(conn) == nil
  end
end
