defmodule PresentrWeb.PresentationLive.Show do
  use PresentrWeb, :live_view

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    Phoenix.PubSub.subscribe(Presentr.PubSub, "#{id}")

    Phoenix.PubSub.broadcast(Presentr.PubSub, "#{id}", {:get_slide_number})

    {:ok,
     socket
     |> assign(:slide, 0)}
  end

  @impl true
  def handle_event("keypress", %{"code" => _}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:new_slide, %{slide: slide}}, socket) do
    if slide != socket.assigns.slide do
      {:noreply, assign(socket, :slide, slide)}
    else
      {:noreply, socket}
    end
  end

  def handle_info({:get_slide_number}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:presentation_id, id)
     |> assign(:slides, get_slides(id))}
  end

  defp page_title(_title), do: "Presentr"

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
