defmodule Blog.Abilities do
  alias Blog.User
  defimpl Canada.Can, for: User do
    def can?(%Blog.User{}, action, User) when action in [:index, :new, :create], do: true
    def can?(%Blog.User{}, :show, %User{}), do: true
    def can?(%Blog.User{id: id}, _, %User{id: id}), do: true

    # Allow the not_found_handler to catch resources that are not found
    def can?(%Blog.User{}, _, resource) when resource in [nil, []], do: true
    def can?(%Blog.User{}, _, _), do: false # catchall to ensure that a user can only do what we permit
  end

  defimpl Canada.Can, for: Atom do
    # a user that is not logged in cannot do anything except create a new user
    def can?(nil, action, User) when action in [:new, :create], do: true
    def can?(nil, _, _), do: false
  end
end
