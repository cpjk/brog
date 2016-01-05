defmodule Blog.ControllerHelpers do
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import Plug.Conn, only: [halt: 1]

  def redirect_on_not_found(conn) do
    conn
    |> put_flash(:error, "That resource does not exist!")
    |> redirect(to: "/")
    |> halt
  end

  def handle_unauthorized(conn) do
    conn
    |> put_flash(:error, "You can't access that resource!")
    |> redirect(to: "/")
    |> halt
  end
end
