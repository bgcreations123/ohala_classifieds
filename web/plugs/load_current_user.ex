defmodule OhalaClassifieds.LoadCurrentUser do
  # Pass Config
  def init(opts) do
    opts
  end

  # Runs when you make a request
  def call(conn, opts) do
    user_id = Plug.Conn.get_session(conn, :user_id)
    if user_id do
      user = OhalaClassifieds.Repo.get(OhalaClassifieds.User, user_id)
      Plug.Conn.assign(conn, :current_user, user)
    else
      conn
    end
  end
end