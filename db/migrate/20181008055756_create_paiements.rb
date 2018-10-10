class CreatePaiements < ActiveRecord::Migration[5.2]
  def change
    create_table :paiements do |t|
      t.string      :objet
      t.integer     :montant, limit: 3
      t.text        :facture
      t.text        :note
      t.references  :ic_module, foreign_key: true

      t.timestamps
    end
  end
end
