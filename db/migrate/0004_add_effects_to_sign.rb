class AddEffectsToSign < ActiveRecord::Migration
  def change
    add_column :signs, :effects, :integer
    add_index :signs, :effects
  end
end
