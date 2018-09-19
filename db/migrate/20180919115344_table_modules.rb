class TableModules < ActiveRecord::Migration[5.2]
  def change

    create_table :abs_modules
    add_column :abs_modules, :titre,  :string  # Le titre du module
    add_column :abs_modules, :dim,    :string # pour le diminutif, p.e. 'stt' pour Structure
    add_column :abs_modules, :long_description, :text # description longue
    add_column :abs_modules, :short_description, :text # description courte

  end
end
