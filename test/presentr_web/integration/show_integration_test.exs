defmodule Presentr.ShowIntegrationTest do
  use PresentrWeb.IntegrationCase, async: true

  test "Basic page flow", %{conn: conn} do
    # get the root index page
    get(
      conn,
      Routes.presentation_show_path(conn, :show, "2a82a8aee193d76c4dd90e6ab2e966b6")
    )
    # click/follow through the various about pages
    |> assert_response(
      status: 200,
      path: Routes.presentation_show_path(conn, :show, "2a82a8aee193d76c4dd90e6ab2e966b6"),
      html: "Viewing Presentation"
    )
  end
end
