# ---- creating a Module Plug
defmodule HelloWeb.Plugs.Locale do
  import Plug.Conn

  @locales ['en', 'fr', 'de']

  def init(default), do: default

  def call(%Plug.Conn{params: %{"locale" => loc}} = conn, _default) when loc in @locales do
    assign(conn, :locale, loc)
  end

  def call(conn, default), do: assign(conn, :locale, default)
end



defmodule HelloWeb.Router do
  use HelloWeb, :router

  pipeline :browser do
    plug :accepts, ["html", "text"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    # ---- Using the custom Module Plug
    plug HelloWeb.Plugs.Locale, 'en'
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HelloWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/hello", HelloController, :index
    get "/hello/:id", HelloController, :show

    forward "/jobs", BackgroundJob.Plug, name: "Hello Phoenix"

#    resources "/users", UserController do
#      resources "/posts", PostController
#    end

    resources "/reviews", ReviewController

  end

  scope "/reviews", HelloWeb do
#    pipe_through [:browser, :review_checks]

    resources "/", ReviewController
  end

  # Other scopes may use custom stacks.
  # scope "/api", HelloWeb do
  #   pipe_through :api
  # end

  scope "/admin", HelloWeb.Admin, as: :admin do
    pipe_through :browser

    resources "/images",  ImageController
    resources "/reviews", ReviewController
    resources "/users",   UserController
  end




end
