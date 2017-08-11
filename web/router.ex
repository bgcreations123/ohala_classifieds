defmodule OhalaClassifieds.Router do
  use OhalaClassifieds.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession # looks in the session for the token
    plug Guardian.Plug.LoadResource
    plug OhalaClassifieds.CurrentUser
  end

  pipeline :authentication_required do
    plug Guardian.Plug.EnsureAuthenticated,
    handler: OhalaClassifieds.GuardianErrorHandler
  end

  pipeline :backend_authentication_required do
    plug OhalaClassifieds.CheckAdmin
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader # Looks in the Authorization header for the token
    plug Guardian.Plug.LoadResource
  end

  scope "/", OhalaClassifieds do
    pipe_through [:browser, :browser_session] # Use the default browser stack

    get "/", PageController, :index
    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
    resources "/login", SessionController, only: [:new, :create, :delete]
    get "/ads", AdsController, :ads
    get "/ad/:id", AdsController, :view_ad


    # registered user zone
    scope "/" do
      pipe_through [:authentication_required]
      resources "/user", UserController, only: [:show]
      resources "/ads", AdsController

      # member zone
      scope "/member", Member, as: :member do
        pipe_through []
        resources "/user", UserController do
          resources "/ads", AdsController
        end
      end

      # backend zone
      scope "/backend", Backend, as: :backend do
        pipe_through [:backend_authentication_required]
        get "/user/:user_id/user_role/:role_id/edit", UserController, :edit_user_role
        put "/user/:user_id/user_role/:role_id", UserController, :update_user_role
        get "/user/:user_id/trigger", UserController, :trigger_action
        resources "/user", UserController do
          resources "/ads", AdsController
        end
      end
    end

  end

  # Other scopes may use custom stacks.
  # scope "/api", OhalaClassifieds do
  #   pipe_through :api
  # end
end
