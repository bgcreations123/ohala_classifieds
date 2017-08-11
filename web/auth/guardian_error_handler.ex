defmodule OhalaClassifieds.GuardianErrorHandler do
  import OhalaClassifieds.Router.Helpers

  def unauthenticated(conn, _params) do
    conn
    |> Phoenix.Controller.put_flash(:error, "Access Denied.")
    |> Phoenix.Controller.redirect(to: session_path(conn, :new))
  end
end