class CreateIcDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :ic_documents do |t|
      t.string      :original_name
      t.string      :affixe
      t.datetime    :commented_at
      t.integer     :note_auteur,         limit: 2
      t.string      :original_options,    limit: 8
      t.string      :comments_options,    limit: 8
      t.integer     :original_cote,       limit: 1
      t.integer     :comments_cote,       limit: 1
      t.references  :ic_etape,            foreign_key: true

      t.timestamps
    end
  end
end
