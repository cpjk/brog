defmodule Blog.User do
  use Blog.Web, :model

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :encrypted_password
    field :password, :string, virtual: true

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
