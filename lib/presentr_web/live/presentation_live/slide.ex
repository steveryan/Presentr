defmodule PresentrWeb.PresentationLive.Slide do
  use PresentrWeb, :live_component

  def render(assigns) do
    ~L"""
    <div>
      <%= raw(Earmark.as_html!(Enum.at(@html,@slide))) %>
    </div>
    """
  end
end
