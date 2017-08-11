defmodule OhalaClassifieds.Member.AdsController do
  use OhalaClassifieds.Web, :controller

  alias OhalaClassifieds.User
  alias OhalaClassifieds.Ads

  def index(conn, %{"user_id" => user_id}) do
    user = User
    |> Repo.get!(user_id)

    ad = %User{}
    |> user_ads
    |> Repo.all
    |> Repo.preload(:user)

    if user do
      render(conn, "index.html", ad: ad, user: user)
    else
      conn
      |> put_flash(:info, "Oops, You have Authorisation issues...!")
      |> render(AuthStudy.ErrorView, "404.html")
    end
  end

  def new(conn, %{"user_id" => user_id}) do
    changeset =
      User
      |> build_assoc(:ads)
      |> Ads.changeset

    user = User
    |> Repo.get!(user_id)

    if user do
      render(conn, "new.html", changeset: changeset)
    else
      conn
      |> put_flash(:info, "Oops, You have Authorisation issues...!")
      |> render(AuthStudy.ErrorView, "404.html")
    end
  end

  def create(conn, %{"ads" => ads_params}, current_user) do
    changeset =
      current_user
      |> build_assoc(:posts)
      |> Ads.changeset(ads_params)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Ad was created successfully")
        |> redirect(to: ads_path(conn, :index, current_user.id))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp user_ads(user) do
    user
    |> assoc(:ads)
    |> where([a], a.approved == true)
  end

  defp user_ad_by_id(user, ad_id) do
    user
    |> user_ads
    |> Repo.get(ad_id)
  end
end