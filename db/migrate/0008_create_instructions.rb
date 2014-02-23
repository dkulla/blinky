class CreateInstructions < ActiveRecord::Migration
  def change
    create_table :instructions do |t|
      t.integer :sequence_id
      t.integer :number
      t.text    :phrase
      t.integer :effects
      t.string  :color
      t.string  :background_color
      t.float   :fade_time
      t.float   :tempo

      t.timestamps
    end
  end
end
