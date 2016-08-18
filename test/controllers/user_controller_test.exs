defmodule Blog.UserControllerTest do
  use Blog.ConnCase

  alias Blog.User

  @valid_new_user_attrs %{first_name: "Morty",
    last_name: "Smith",
    email: "morty@earth.com",
    password: "ohgeeze"}
  @valid_stored_user_attrs Map.delete(@valid_new_user_attrs, :password)

  @valid_current_user_attrs %{first_name: "Rick",
    last_name: "Sanchez",
    email: "ricksanchez@earth.com",
    password: "rickytickytavy"}
  @valid_login_attrs %{email: "ricksanchez@earth.com",
    password: "rickytickytavy"}
  @invalid_attrs %{}


  setup do
    conn = build_conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    TestHelpers.create_user(@valid_current_user_attrs)
    conn = TestHelpers.login_user(conn, @valid_login_attrs)

    conn = get conn, user_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing users"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "New user"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    TestHelpers.create_user(@valid_current_user_attrs)
    conn = TestHelpers.login_user(conn, @valid_login_attrs)

    conn = post conn, user_path(conn, :create), user: @valid_new_user_attrs
    assert redirected_to(conn) == user_path(conn, :index)
    assert Repo.get_by(User, @valid_stored_user_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    TestHelpers.create_user(@valid_current_user_attrs)
    conn = TestHelpers.login_user(conn, @valid_login_attrs)

    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "New user"
  end

  test "shows chosen resource", %{conn: conn} do
    TestHelpers.create_user(@valid_current_user_attrs)
    conn = TestHelpers.login_user(conn, @valid_login_attrs)

    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :show, user)
    assert html_response(conn, 200) =~ "Show user"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    conn = get conn, user_path(conn, :show, -1)
    assert html_response(conn, 302) =~ "/"
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    current_user = TestHelpers.create_user(@valid_current_user_attrs)
    conn = TestHelpers.login_user(conn, @valid_login_attrs)

    conn = get conn, user_path(conn, :edit, current_user)
    assert html_response(conn, 200) =~ "Edit user"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    current_user = TestHelpers.create_user(@valid_current_user_attrs)
    conn = TestHelpers.login_user(conn, @valid_login_attrs)

    new_attrs = Map.put(@valid_current_user_attrs, :first_name, "James")
    |> Map.delete(:password)

    conn = put conn, user_path(conn, :update, current_user), user: new_attrs
    assert redirected_to(conn) == user_path(conn, :show, current_user)
    assert Repo.get_by(User, new_attrs)
  end

  test "deletes chosen resource", %{conn: conn} do
    current_user = TestHelpers.create_user(@valid_current_user_attrs)
    conn = TestHelpers.login_user(conn, @valid_login_attrs)

    conn = delete conn, user_path(conn, :delete, current_user)
    assert redirected_to(conn) == user_path(conn, :index)
    refute Repo.get(User, current_user.id)
  end
end
