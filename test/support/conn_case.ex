defmodule SandboxWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use SandboxWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import SandboxWeb.ConnCase

      alias SandboxWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint SandboxWeb.Endpoint

      def auth_header(conn, user_id) do
        token = Base.encode64(user_id)
        header = "Basic " <> "test_#{token}"

        conn
        |> put_req_header("authorization", header)
        |> put_req_header("content-type", "application/json")
      end
    end
  end

  setup _tags do
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
