defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  plug Ueberauth

  alias Discuss.User

  def callback(%{assigns: %{ueberauth_auth: auth}}, %{provider: provider}) do
    user_params = %{token: auth.credentials.params, email: auth.info.email, provider: provider}
    changeset = User.changeset(%User{}, user_params)

    upsert_user(changeset)
  end

  defp upsert_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end
