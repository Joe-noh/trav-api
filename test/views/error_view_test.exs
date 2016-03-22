defmodule Trav.ErrorViewTest do
  use Trav.ConnCase, async: true

  import Phoenix.View

  test "renders 404.json" do
    assert render(Trav.ErrorView, "404.json", []) == %{errors: %{detail: "Page not found"}}
  end

  test "render 500.json" do
    assert render(Trav.ErrorView, "500.json", []) == %{errors: %{detail: "Server internal error"}}
  end

  test "render any other" do
    assert render(Trav.ErrorView, "505.json", []) == %{errors: %{detail: "Server internal error"}}
  end
end
