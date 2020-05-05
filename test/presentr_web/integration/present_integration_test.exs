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

    assert page_title() == "Presentr · Phoenix Framework"
  end
end
