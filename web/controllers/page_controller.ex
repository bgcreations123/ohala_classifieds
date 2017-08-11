defmodule OhalaClassifieds.PageController do
  use OhalaClassifieds.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
