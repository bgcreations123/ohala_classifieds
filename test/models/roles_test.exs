defmodule OhalaClassifieds.RolesTest do
  use OhalaClassifieds.ModelCase

  alias OhalaClassifieds.Roles

  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Roles.changeset(%Roles{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Roles.changeset(%Roles{}, @invalid_attrs)
    refute changeset.valid?
  end
end
