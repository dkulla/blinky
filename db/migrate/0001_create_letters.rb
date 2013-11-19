class CreateLetters < ActiveRecord::Migration
  def change
    create_table :letters do |t|
      t.text :segment_order
      t.belongs_to :sign, index: true

      t.timestamps
    end
  end
end
