defmodule OhalaClassifieds.User_RolesTest do
  use OhalaClassifieds.ModelCase

  alias OhalaClassifieds.User_Roles

  @valid_attrs %{role_id: "some content", user_id: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User_Roles.changeset(%User_Roles{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User_Roles.changeset(%User_Roles{}, @invalid_attrs)
    refute changeset.valid?
  end
end
