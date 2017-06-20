class CreateVisits < ActiveRecord::Migration[5.0]
  def change
    create_table :visits do |t|
      t.integer :short_url_id, null: false
      t.integer :submitter_id, null: false

      t.timestamps
    end

    add_index :visits, :short_url_id
    add_index :visits, :submitter_id

  end
end
