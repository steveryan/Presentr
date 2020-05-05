defmodule PresentrWeb.PresentationLive.Present do
  use PresentrWeb, :live_view

  @impl true
  @spec mount(map(), any, %Phoenix.LiveView.Socket{}) :: {:ok, %Phoenix.LiveView.Socket{}}
  def mount(%{"id" => id}, _session, socket) do
    Phoenix.PubSub.subscribe(Presentr.PubSub, "#{id}")

    Phoenix.PubSub.broadcast_from(
      Presentr.PubSub,
      self(),
      "#{id}",
      {:new_slide,
       %{
         slide: 0
       }}
    )

    {:ok, socket}
  end

  @impl true
  @spec handle_event(binary(), map(), %Phoenix.LiveView.Socket{}) ::
          {:noreply, %Phoenix.LiveView.Socket{}}
  def handle_event("keypress", %{"code" => "ArrowRight"}, socket) do
    new_slide =
      if Enum.at(socket.assigns.slides, socket.assigns.slide + 1),
        do: socket.assigns.slide + 1,
        else: socket.assigns.slide

    Phoenix.PubSub.broadcast_from(
      Presentr.PubSub,
      self(),
      "#{socket.assigns.presentation_id}",
      {:new_slide,
       %{
         slide: new_slide
       }}
    )

    {:noreply, assign(socket, :slide, new_slide)}
  end

  @impl true
  def handle_event("keypress", %{"code" => "ArrowLeft"}, socket) do
    new_slide =
      if socket.assigns.slide != 0,
        do: socket.assigns.slide - 1,
        else: socket.assigns.slide

    Phoenix.PubSub.broadcast_from(
      Presentr.PubSub,
      self(),
      "#{socket.assigns.presentation_id}",
      {:new_slide,
       %{
         slide: new_slide
       }}
    )

    {:noreply, assign(socket, :slide, new_slide)}
  end

  def handle_event("keypress", %{"code" => _}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("next", _value, socket) do
    new_slide =
      if Enum.at(socket.assigns.slides, socket.assigns.slide + 1),
        do: socket.assigns.slide + 1,
        else: socket.assigns.slide

    Phoenix.PubSub.broadcast_from(
      Presentr.PubSub,
      self(),
      "#{socket.assigns.presentation_id}",
      {:new_slide,
       %{
         slide: new_slide
       }}
    )

    {:noreply, assign(socket, :slide, new_slide)}
  end

  @impl true
  def handle_event("previous", _value, socket) do
    new_slide =
      if socket.assigns.slide != 0,
        do: socket.assigns.slide - 1,
        else: socket.assigns.slide

    Phoenix.PubSub.broadcast_from(
      Presentr.PubSub,
      self(),
      "#{socket.assigns.presentation_id}",
      {:new_slide,
       %{
         slide: new_slide
       }}
    )

    {:noreply, assign(socket, :slide, new_slide)}
  end

  @impl true
  @spec handle_info({atom(), map()}, %Phoenix.LiveView.Socket{}) ::
          {:noreply, %Phoenix.LiveView.Socket{}}
  def handle_info({:new_slide, %{slide: slide}}, socket) do
    {:noreply, assign(socket, :slide, slide)}
  end

  def handle_info({:get_slides_and_slide_number}, socket) do
    Phoenix.PubSub.broadcast_from(
      Presentr.PubSub,
      self(),
      "#{socket.assigns.presentation_id}",
      {:slides_and_slide_number,
       %{
         slides: socket.assigns.slides,
         slide: socket.assigns.slide
       }}
    )

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
     |> assign(:slides, get_slides(id))
     |> assign(:slide, 0)}
  end

  @spec page_title(any()) :: String.t()
  defp page_title(_title), do: "Presentr"

  @spec get_slides(String.t()) :: Enum.t() | String.t()
  defp get_slides(id) do
    case HTTPoison.get("https://api.github.com/gists/#{id}",
           Authorization: Application.get_env(:presentr, :token)
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode!()
        |> Map.fetch!("files")
        |> Enum.at(0)
        |> elem(1)
        |> Map.fetch!("content")
        |> String.split("\n\n---\n\n")

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        "Gist Not Found :("

      {:error, %HTTPoison.Error{reason: reason}} ->
        "Error: #{reason}"
    end
  end
end
