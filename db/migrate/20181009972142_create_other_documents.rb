class CreateOtherDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :other_documents do |t|
      t.string      :dtype,               limit: 4
      t.string      :original_name
      t.string      :affixe
      t.datetime    :commented_at
      t.string      :original_options,    limit: 8
      t.string      :comments_options,    limit: 8
      t.references  :user,                foreign_key: true

      t.timestamps
    end
  end
end
