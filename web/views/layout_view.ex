defmodule OhalaClassifieds.LayoutView do
  use OhalaClassifieds.Web, :view

  def user_signed_in?(conn) do
    !!conn.assigns.current_user
  end
end
