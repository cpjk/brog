defmodule Blog.User do
  use Blog.Web, :model

  alias Blog.User
  alias Blog.Repo

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :encrypted_password
    field :password, :string, virtual: true
    has_many :comments, Blog.Comment

    timestamps
  end

  @required_create_fields ~w(first_name last_name email password)
  @optional_create_fields ~w()

  @required_update_fields ~w()
  @optional_update_fields ~w(first_name last_name email password)

  before_insert :maybe_update_password
  before_update :maybe_update_password

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def create_changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_create_fields, @optional_create_fields)
  end

  def update_changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_update_fields, @optional_update_fields)
  end

  def new_session_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(email password), ~w())
  end

  def create_session_changeset(params = %{"email" => email, "password" => password}) do
    email
    |> by_email
    |> Repo.one
    |> check_pw(params)
  end

  def by_email(email) do
    from u in User, where: u.email == ^email
  end

  # If the user cannot be found, do a dummy check to prevent timing
  # attacks and report that the email/password combination did not match
  defp check_pw(nil, params) do
    Comeonin.Bcrypt.dummy_checkpw

    %User{}
    |> new_session_changeset(params) # give the params back so we can refill the form fields
    |> Ecto.Changeset.add_error(:email, "and password do not match")
  end

  defp check_pw(user = %User{}, params = %{"password" => password}) do
    Comeonin.Bcrypt.checkpw(password, user.encrypted_password)
    |> case do
      true  ->
        user
        |> new_session_changeset(params)
      false ->
        %User{}
        |> new_session_changeset(params)
        |> Ecto.Changeset.add_error(:email, "and password do not match")
    end
  end

  @doc """
  Update the password if a new password was provided
  """
  defp maybe_update_password(changeset) do
    case Ecto.Changeset.fetch_change(changeset, :password) do
      {:ok, password} ->
        changeset
        |> Ecto.Changeset.put_change(:encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      :error -> changeset
    end
  end
end
