class CreateIcModules < ActiveRecord::Migration[5.2]
  def change
    create_table :ic_modules do |t|
      t.string      :project_name
      t.integer     :state,         limit: 2
      t.datetime    :started_at
      t.datetime    :ended_at
      t.datetime    :next_paiement
      t.references  :abs_module,    foreign_key: true
      t.references  :current_etape, references: :ic_etape
      
      t.timestamps
    end
  end
end
