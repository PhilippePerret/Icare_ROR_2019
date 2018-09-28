class CreateIcEtapes < ActiveRecord::Migration[5.2]
  def change
    create_table :ic_etapes do |t|
      t.integer     :status,                limit: 2,   default: 0
      t.string      :options,               limit: 16
      t.text        :travail_propre
      t.datetime    :started_at
      t.datetime    :expected_end_at
      t.datetime    :ended_at
      t.datetime    :expected_comments_at
      t.references  :ic_module,               foreign_key: true

      t.timestamps
    end
  end
end
