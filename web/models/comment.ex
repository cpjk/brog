defmodule Blog.Comment do
  use Blog.Web, :model

  schema "comments" do
    field :text, :string
    belongs_to :user, Blog.User

    timestamps
  end

  @required_fields ~w(text user_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def create_changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
