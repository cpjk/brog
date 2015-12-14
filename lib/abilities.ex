defmodule Blog.Abilities do
  alias Blog.User
  defimpl Canada.Can, for: Blog.User do
    def can?(%Blog.User{}, action, Blog.User) when action in [:index, :create], do: true
    def can?(%Blog.User{id: id}, _, %Blog.User{id: id}), do: true
    def can?(%Blog.User{}, _, _), do: false # catchall to ensure that a user can only do what we permit
  end

  defimpl Canada.Can, for: Atom do
    def can?(nil, _, _), do: false # a user that is not logged in cannot do anything
  end
end
