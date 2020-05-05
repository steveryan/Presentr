defmodule Presentr.ShowIntegrationTest do
  use ExUnit.Case
  use Hound.Helpers

  hound_session()

  test "Page functionality" do
    in_browser_session("presenter", fn ->
      navigate_to(
        PresentrWeb.Router.Helpers.presentation_present_path(
          PresentrWeb.Endpoint,
          :present,
          "2a82a8aee193d76c4dd90e6ab2e966b6"
        )
      )
    end)

    # Viewer on First page of the test presentation
    navigate_to(
      PresentrWeb.Router.Helpers.presentation_show_path(
        PresentrWeb.Endpoint,
        :show,
        "2a82a8aee193d76c4dd90e6ab2e966b6"
      )
    )

    assert visible_page_text() =~ "Working Like A Developer"

    # Presenter advance to second page of test presentation
    in_browser_session("presenter", fn ->
      next_button = find_element(:id, "next")
      click(next_button)
    end)

    # Viewer on second page of test presentation, viewer refreshes and is still on correct slide
    assert visible_page_text() =~ "Agenda"
    refresh_page()
    assert visible_page_text() =~ "Agenda"

    # A second viewer joins and should see the current slide (2)

    in_browser_session("viewer2", fn ->
      navigate_to(
        PresentrWeb.Router.Helpers.presentation_show_path(
          PresentrWeb.Endpoint,
          :show,
          "2a82a8aee193d76c4dd90e6ab2e966b6"
        )
      )

      assert visible_page_text() =~ "Agenda"
    end)

    # Presenter goes back to first page of test presentation
    in_browser_session("presenter", fn ->
      send_keys(:left_arrow)
    end)

    # Viewer on first page of test presentation
    assert visible_page_text() =~ "Working Like A Developer"

    # Presenter try to navigate to previous page of test presentation (doesn't exist)
    in_browser_session("presenter", fn ->
      previous_button = find_element(:id, "previous")
      click(previous_button)
    end)

    # Viewer ensure still on first page of test presentation
    assert visible_page_text() =~ "Working Like A Developer"
  end
end
