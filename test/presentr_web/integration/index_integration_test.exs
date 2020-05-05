defmodule Presentr.IndexIntegrationTest do
  use ExUnit.Case
  use Hound.Helpers

  hound_session()

  test "Page functionality" do
    navigate_to(
      PresentrWeb.Router.Helpers.presentation_index_path(
        PresentrWeb.Endpoint,
        :index
      )
    )

    # Index Page looks as it should
    assert visible_page_text() =~ "Welcome to Presentr"
    assert visible_page_text() =~ "Enter a Gist ID below to present"

    # Fill in gist ID of presentation and hit enter
    text_input = find_element(:id, "gist_id_id")
    fill_field(text_input, "2a82a8aee193d76c4dd90e6ab2e966b6")
    submit_element(text_input)
    Process.sleep(250)
    # Ensure that presentation loads in presentation mode
    assert visible_page_text() =~ "Working Like A Developer"
    previous_button = find_element(:id, "previous")
    element_displayed?(previous_button)
    next_button = find_element(:id, "next")
    element_displayed?(next_button)
  end
end
