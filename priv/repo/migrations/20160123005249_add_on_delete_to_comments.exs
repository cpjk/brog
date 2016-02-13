defmodule Blog.Repo.Migrations.AddOnDeleteToComments do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE comments DROP CONSTRAINT comments_user_id_fkey"
    alter table(:comments) do
      modify :user_id, references(:users, on_delete: :delete_all)
    end
  end

  def down do
    execute "ALTER TABLE comments DROP CONSTRAINT comments_user_id_fkey"
    alter table(:comments) do
      modify :user_id, references(:users, on_delete: :nothing)
    end
  end
end
