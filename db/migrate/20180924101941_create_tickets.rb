class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.belongs_to :user, index: true
      t.string    :name          # Pour le nom du ticket et le titre du lien
      t.string    :digest
      t.string    :action
      t.datetime  :expire_at

      t.timestamps
    end
    add_index :tickets, :digest, unique: true
  end
end
