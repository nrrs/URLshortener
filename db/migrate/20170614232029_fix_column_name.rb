class FixColumnName < ActiveRecord::Migration[5.0]
  def change
    change_table :visits do |t|
      t.rename :submitter_id, :visitor_id
    end
  end
end
