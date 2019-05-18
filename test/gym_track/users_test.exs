defmodule GymTrack.UsersTest do
  use GymTrack.DataCase

  alias GymTrack.Users

  describe "users" do
    alias GymTrack.Users.User

    @valid_attrs %{email: "example@example.com", password: "some-password"}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Users.create_user(@valid_attrs)

      assert user.email == "example@example.com"
      assert user.password_hash
      refute user.password_hash == "some-password"
    end

    test "create_user/1 with missing email returns error changeset" do
      invalid_attrs = %{email: nil, password: "some-password"}
      assert {:error, %Ecto.Changeset{} = changeset} = Users.create_user(invalid_attrs)
      assert "can't be blank" in errors_on(changeset).email
    end

    test "create_user/1 with invalid email returns error changeset" do
      invalid_attrs = %{email: "someemail", password: "some-password"}
      assert {:error, %Ecto.Changeset{} = changeset} = Users.create_user(invalid_attrs)
      assert "has invalid format" in errors_on(changeset).email
    end

    test "create_user/1 with missing password returns error changeset" do
      invalid_attrs = %{email: "example@example.com", password: nil}
      assert {:error, %Ecto.Changeset{} = changeset} = Users.create_user(invalid_attrs)
      assert "can't be blank" in errors_on(changeset).password
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
