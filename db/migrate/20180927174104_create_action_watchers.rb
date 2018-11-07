class CreateActionWatchers < ActiveRecord::Migration[5.2]
  def change
    create_table :action_watchers do |t|
      t.string        :model,       limit: 50
      t.integer       :model_id
      t.string        :action
      t.datetime      :triggered_at
      t.text          :data
      t.references    :user,        foreign_key: true

      t.timestamps
    end
  end
end
