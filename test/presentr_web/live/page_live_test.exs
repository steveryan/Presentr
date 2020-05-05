defmodule PresentrWeb.PageLiveTest do
  use PresentrWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Welcome to Presentr"
    assert render(page_live) =~ "Welcome to Presentr"
  end
end
