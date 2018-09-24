class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|

      t.string    :name
      t.string    :nom
      t.string    :prenom
      t.int       :sexe,      limit: 1
      t.int       :birthyear, limit: 4

      t.string    :email
      t.string    :password_digest
      t.string    :remember_digest

      t.int       :statut,  default: 0, limit: 2
      t.string    :options, default: '00000000'

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
