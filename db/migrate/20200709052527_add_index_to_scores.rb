class AddIndexToScores < ActiveRecord::Migration[6.0]
  def change
    add_index :scores,  :name
  end
end
