defmodule PresentrWeb.PresentationLiveTest do
  use PresentrWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "Index" do
    test "Explains what to do", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.presentation_index_path(conn, :index))

      assert html =~
               "Presentr allows you to present your markdown slides hosted on <a href=\"http://gist.github.com\">gist.github.com</a> to anyone, anywhere without setting up any screen-sharing."

      assert html =~ "Enter a Gist ID below to present"

      assert html =~
               "<input id=\"gist_id_id\" name=\"gist_id[id]\" phx-debounce=\"300\" placeholder=\"Gist ID\" type=\"text\" autofocus=\"autofocus\"/>"
    end
  end
end
