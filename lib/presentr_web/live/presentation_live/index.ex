defmodule PresentrWeb.PresentationLive.Index do
  use PresentrWeb, :live_view

  @impl true
  @spec mount(map(), any, %Phoenix.LiveView.Socket{}) :: {:ok, %Phoenix.LiveView.Socket{}}
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  @spec handle_event(binary(), map(), %Phoenix.LiveView.Socket{}) ::
          {:noreply, %Phoenix.LiveView.Socket{}}
  def handle_event("id", %{"gist_id" => %{"id" => id}}, socket) do
    {:noreply,
     Phoenix.LiveView.push_redirect(
       socket,
       to:
         Routes.presentation_present_path(
           PresentrWeb.Endpoint,
           :present,
           id
         )
     )}
  end

  @impl true
  @spec handle_params(map, any, Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Presentr")
  end
end
