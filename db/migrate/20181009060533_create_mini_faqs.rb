class CreateMiniFaqs < ActiveRecord::Migration[5.2]
  def change
    create_table :mini_faqs do |t|
      t.references    :user,        foreign_key: true
      t.references    :abs_etape,   foreign_key: true
      t.text          :question
      t.text          :reponse
      t.integer       :state,       limit: 1

      t.timestamps
    end
  end
end
