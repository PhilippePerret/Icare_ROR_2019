class AddProperitesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :statut,     :smallint # 2 chiffres
    add_column :users, :nom,        :string
    add_column :users, :prenom,     :string
    add_column :users, :birthyear,  :int4
    add_column :users, :sexe,       :tinyint # 0=homme, 1=femme
  end
end
