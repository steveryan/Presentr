defmodule PresentrWeb.PresentationLiveTest do
  use PresentrWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Presentr.Context

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp fixture(:presentation) do
    {:ok, presentation} = Context.create_presentation(@create_attrs)
    presentation
  end

  defp create_presentation(_) do
    presentation = fixture(:presentation)
    %{presentation: presentation}
  end

  describe "Index" do
    setup [:create_presentation]

    test "lists all presentations", %{conn: conn, presentation: presentation} do
      {:ok, _index_live, html} = live(conn, Routes.presentation_index_path(conn, :index))

      assert html =~ "Listing Presentations"
    end

    test "saves new presentation", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.presentation_index_path(conn, :index))

      assert index_live |> element("a", "New Presentation") |> render_click() =~
        "New Presentation"

      assert_patch(index_live, Routes.presentation_index_path(conn, :new))

      assert index_live
             |> form("#presentation-form", presentation: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#presentation-form", presentation: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.presentation_index_path(conn, :index))

      assert html =~ "Presentation created successfully"
    end

    test "updates presentation in listing", %{conn: conn, presentation: presentation} do
      {:ok, index_live, _html} = live(conn, Routes.presentation_index_path(conn, :index))

      assert index_live |> element("#presentation-#{presentation.id} a", "Edit") |> render_click() =~
        "Edit Presentation"

      assert_patch(index_live, Routes.presentation_index_path(conn, :edit, presentation))

      assert index_live
             |> form("#presentation-form", presentation: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#presentation-form", presentation: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.presentation_index_path(conn, :index))

      assert html =~ "Presentation updated successfully"
    end

    test "deletes presentation in listing", %{conn: conn, presentation: presentation} do
      {:ok, index_live, _html} = live(conn, Routes.presentation_index_path(conn, :index))

      assert index_live |> element("#presentation-#{presentation.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#presentation-#{presentation.id}")
    end
  end

  describe "Show" do
    setup [:create_presentation]

    test "displays presentation", %{conn: conn, presentation: presentation} do
      {:ok, _show_live, html} = live(conn, Routes.presentation_show_path(conn, :show, presentation))

      assert html =~ "Show Presentation"
    end

    test "updates presentation within modal", %{conn: conn, presentation: presentation} do
      {:ok, show_live, _html} = live(conn, Routes.presentation_show_path(conn, :show, presentation))

      assert show_live |> element("a", "Edit") |> render_click() =~
        "Edit Presentation"

      assert_patch(show_live, Routes.presentation_show_path(conn, :edit, presentation))

      assert show_live
             |> form("#presentation-form", presentation: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#presentation-form", presentation: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.presentation_show_path(conn, :show, presentation))

      assert html =~ "Presentation updated successfully"
    end
  end
end
