class TableModules < ActiveRecord::Migration[5.2]
  def change

    create_table :abs_modules do |t|
      t.string  :name
      t.string  :dim    #pour le diminutif, p.e. 'stt' pour Structure
      t.integer :module_id,     limit: 2
      t.integer :tarif,         limit: 4
      t.text    :long_description
      t.text    :short_description
      t.integer :nombre_jours,  limit:  3
      t.string  :hduree

      t.timestamps
    end

  end
end
