defmodule HelloWeb.HelloController do
  use HelloWeb, :controller

  plug :assign_welcome_message, "Welcome Back"

  def index(conn, _params) do
#    render(conn, "index.html")

    conn
    |> assign(:message, "Welcome Forward")
    |> assign(:name, "Dweezil")
    |> put_layout("admin.html")
    |> render("index.html")

  end


  defp assign_welcome_message(conn, msg) do
    assign(conn, :message, msg)
  end




#  def show(conn, %{"messenger" => messenger}) do
#    render(conn, "show.html", messenger: messenger)
#  end

  def show(conn, %{"id" => id}) do
#    text(conn, "Showing id #{id}")
    json(conn, %{id: id})
  end
end
