defmodule Presentr.PresentIntegrationTest do
  use ExUnit.Case
  use Hound.Helpers

  hound_session()

  test "Page functionality" do
    navigate_to(
      PresentrWeb.Router.Helpers.presentation_present_path(
        PresentrWeb.Endpoint,
        :present,
        "2a82a8aee193d76c4dd90e6ab2e966b6"
      )
    )

    # First page of the test presentation
    assert visible_page_text() =~ "Working Like A Developer"

    # advance to second page of test presentation
    next_button = find_element(:id, "next")
    click(next_button)

    # second page of test presentation
    assert visible_page_text() =~ "Agenda"

    # go back to first page of test presentation
    send_keys(:left_arrow)

    # first page of test presentation
    assert visible_page_text() =~ "Working Like A Developer"

    # try to navigate to previous page of test presentation (doesn't exist)
    previous_button = find_element(:id, "previous")
    click(previous_button)

    # ensure still on first page of test presentation
    assert visible_page_text() =~ "Working Like A Developer"
  end
end
