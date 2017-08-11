defmodule OhalaClassifieds.AdsController do
  use OhalaClassifieds.Web, :controller

  alias OhalaClassifieds.Ads
  alias OhalaClassifieds.User

  plug :scrub_params, "ads" when action in [:create, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, %{"user_id" => user_id}, current_user) do
    user = User
    |> Repo.get!(user_id)

    ad = %User{}
    |> user_ads
    |> Repo.all
    |> Repo.preload(:user)

    if current_user.id == user.id do
      #render(conn, "index.html", ad: ad, user: user)
    else
      conn
      |> put_flash(:info, "Oops, You have Authorisation issues...!")
      #|> render(AuthStudy.ErrorView, "404.html")
    end
  end

  def ads(conn, _params, _current_user) do
    ads = Ads
    |> where([a], a.approved == true)
    |> Repo.all

    render(conn, :ads, ads: ads)
  end

  def show(conn, %{"user_id" => user_id, "id" => id}, current_user) do
    user = User
    |> Repo.get!(user_id)

    ad = user
    |> user_ad_by_id(id)
    |> where([a], a.approved == true)
    |> Repo.preload(:user)

    if current_user.id == ad.user.id && current_user.authorisation == "default" do
      render(conn, "show.html", ad: ad, user: user)
    else
      conn
      |> put_flash(:info, "Oops, You have Authorisation issues...!")
      |> render(AuthStudy.ErrorView, "404.html")
    end
  end

  def view_ad(conn, %{"id" => id}, _current_user) do
    ad = Ads
    |> where([a], a.approved == true)
    |> Repo.get(id)

    render(conn, "view.html", ad: ad)
  end

  def new(conn, %{"user_id" => user_id}, current_user) do
    changeset =
      current_user
      |> build_assoc(:ads)
      |> Ads.changeset

    user = User
    |> Repo.get!(user_id)

    if current_user.id == user.id || current_user.authorisation == "backend" do
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

  def edit(conn, %{"id" => id}, current_user) do
    ad = current_user
    |> user_ad_by_id(id)
    |> where([a], a.approved == true)

    if ad do
      changeset = Ads.changeset(ad)
      render(conn, "edit.html", ad: ad, changeset: changeset)
    else
      conn
      |> put_status(:not_found)
      |> render(OhalaClassifieds.ErrorView, "404.html")
    end
  end

  def update(conn, %{"id" => id, "ad" => ad_params}, current_user) do
    ad = current_user
    |> user_ad_by_id(id)
    |> where([a], a.approved == true)

    changeset = Ads.changeset(ad, ad_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Ad was updated successfully")
        |> redirect(to: ads_path(conn, :show, current_user.id, ad.id))
      {:error, changeset} ->
        render(conn, "edit.html", ad: ad, changeset: changeset)
    end
  end

  def delete(conn, %{"user_id" => user_id, "id" => id}, current_user) do
    user = User
    |> Repo.get!(user_id)

    ad = user
    |> user_ad_by_id(id)
    |> where([a], a.approved == true)
    |> Repo.preload(:user)

    if current_user.id == ad.user.id || current_user.authorisation == "backend" do
      Repo.delete!(ad)

      conn
      |> put_flash(:info, "Ad was deleted successfully")
      |> redirect(to: ads_path(conn, :index, user.id))
    else
      conn
      |> put_flash(:info, "You can’t delete this Ad")
      |> redirect(to: ads_path(conn, :show, user.id, ad.id))
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