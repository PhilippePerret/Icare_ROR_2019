class CreateIcModules < ActiveRecord::Migration[5.2]
  def change
    create_table :ic_modules do |t|
      t.string      :project_name
      t.integer     :state,         limit: 2,   default: 0
      t.datetime    :started_at
      t.datetime    :ended_at
      t.datetime    :next_paiement
      t.references  :abs_module,    foreign_key: true
      t.integer     :current_etape_id, references: :ic_etape, foreign_key: true
      t.references  :user,          foreign_key: true

      t.timestamps
    end
  end
end
