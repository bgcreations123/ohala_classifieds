defmodule OhalaClassifieds.SessionController do
  use OhalaClassifieds.Web, :controller

  alias OhalaClassifieds.User

  def new(conn, _) do
    changeset = User.new()
    render conn, :new, changeset: changeset
  end

#  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
#    changeset = User.new()
#
#    # Validate the inputs
#    {valid, user} = User.valid_authentication?(email, password)
#    if valid do
#      # Set session such that other requests can use this info
#      conn
#      |> Guardian.Plug.sign_in(user)
#      |> redirect(to: "/")
#    else
#      render conn, :new, changeset: changeset
#    end
#  end


  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    changeset = User.new()

    case OhalaClassifieds.Auth.login_by_email_and_pass(conn, email, password) do
      {:ok, conn} ->
        conn
        |> put_flash(:success, "You’re now signed in!")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html", changeset: changeset)
     end
  end

  def delete(conn, _) do
    conn
    |> OhalaClassifieds.Auth.logout
    |> put_flash(:info, "Good Bye...!")
    |> redirect(to: page_path(conn, :index))
  end

end