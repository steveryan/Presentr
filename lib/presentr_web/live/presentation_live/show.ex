defmodule PresentrWeb.PresentationLive.Show do
  use PresentrWeb, :live_view

  @impl true
  @spec mount(map, any, Phoenix.LiveView.Socket.t()) :: {:ok, Phoenix.LiveView.Socket.t()}
  def mount(%{"id" => id}, _session, socket) do
    Phoenix.PubSub.subscribe(Presentr.PubSub, "#{id}")

    Phoenix.PubSub.broadcast(Presentr.PubSub, "#{id}", {:get_slides_and_slide_number})

    {:ok,
     socket
     |> assign(:slide, 0)}
  end

  @impl true
  @spec handle_event(binary(), map(), %Phoenix.LiveView.Socket{}) ::
          {:noreply, %Phoenix.LiveView.Socket{}}
  def handle_event("keypress", %{"code" => _}, socket) do
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({atom(), map()}, %Phoenix.LiveView.Socket{}) ::
          {:noreply, %Phoenix.LiveView.Socket{}}
  def handle_info({:new_slide, %{slide: slide}}, socket) do
    if slide != socket.assigns.slide do
      {:noreply, assign(socket, :slide, slide)}
    else
      {:noreply, socket}
    end
  end

  def handle_info(
        {:slides_and_slide_number, %{slides: slides, slide: slide}},
        socket
      ) do
    {:noreply,
     socket
     |> assign(:slides, slides)
     |> assign(:slide, slide)}
  end

  def handle_info({:get_slides_and_slide_number}, socket) do
    {:noreply, socket}
  end

  @impl true
  @spec handle_params(map, any, Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:presentation_id, id)
     |> assign(:slides, nil)}
  end

  @spec page_title(any()) :: String.t()
  defp page_title(_title), do: "Presentr"
end
