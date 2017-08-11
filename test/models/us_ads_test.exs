defmodule OhalaClassifieds.UsAdsTest do
  use OhalaClassifieds.ModelCase

  alias OhalaClassifieds.UsAds

  @valid_attrs %{description: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UsAds.changeset(%UsAds{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UsAds.changeset(%UsAds{}, @invalid_attrs)
    refute changeset.valid?
  end
end
