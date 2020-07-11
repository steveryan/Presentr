defmodule PresentrWeb.PresentationLive.Slide do
  use PresentrWeb, :live_component

  def render(assigns) do
    ~L"""
    <div>
      <%= raw(Enum.at(@html,@slide)) %>
    </div>
    """
  end
end
