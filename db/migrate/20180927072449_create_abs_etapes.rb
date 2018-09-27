class CreateAbsEtapes < ActiveRecord::Migration[5.2]
  def change
    create_table :abs_etapes do |t|
      t.integer       :numero, limit: 3
      t.references    :abs_module, foreign_key: true
      t.integer       :type
      t.string        :titre
      t.string        :objectif
      t.text          :travail
      t.text          :methode
      t.integer       :duree,     limit: 3
      t.integer       :duree_max, limit: 4
      t.text          :liens

      t.timestamps
    end
  end
end
