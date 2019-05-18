defmodule GymTrackWeb.RegisterControllerTest do
  use GymTrackWeb.ConnCase

  describe "new registration" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.register_path(conn, :new))
      assert html_response(conn, 200) =~ "Register"
    end
  end

  describe "create registration" do
    test "redirects to index route when data is valid", %{conn: conn} do
      create_attrs = %{email: "example@example.com", password: "some-password"}
      conn = post(conn, Routes.register_path(conn, :create), user: create_attrs)

      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      invalid_attrs = %{email: nil, password: nil}
      conn = post(conn, Routes.register_path(conn, :create), user: invalid_attrs)
      assert html_response(conn, 200) =~ "Register"
    end
  end
end
