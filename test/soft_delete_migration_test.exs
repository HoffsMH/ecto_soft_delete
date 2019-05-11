defmodule Ecto.SoftDelete.Migration.Test do
  use ExUnit.Case
  use Ecto.Migration
  alias Ecto.SoftDelete.Test.Repo
  import Ecto.SoftDelete.Migration
  alias Ecto.Migration.Runner

  setup meta do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    {:ok, runner} = Runner.start_link(self(), Repo, meta[:direction] || :forward, :up, %{level: false, sql: false})
    Runner.metadata(runner, meta)
    {:ok, runner: runner}
  end

  test "soft_delete_column adds deleted_at column", %{runner: runner} do
    create table(:posts, primary_key: false) do
      soft_delete_column()
    end

    [create_command] = Agent.get(runner, & &1.commands)

    flush()

    assert {:create, _,
       [{:add, :deleted_at, :utc_datetime, []}]} = create_command
  end

  test "soft_delete_columns also adds deleted_at column for backwards compatability", %{runner: runner} do
    create table(:posts, primary_key: false) do
      soft_delete_columns()
    end

    [create_command] = Agent.get(runner, & &1.commands)

    flush()

    assert {:create, _,
       [{:add, :deleted_at, :utc_datetime, []}]} = create_command
  end
end
