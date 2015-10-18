defmodule Blog.Repo.Migrations.AddEmailEncryptedPasswordToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :encrypted_password, :string
      add :email, :string
    end
  end
end
