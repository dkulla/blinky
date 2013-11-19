class CreateSigns < ActiveRecord::Migration
  def change
    create_table :signs do |t|
      t.text :phrase

      t.timestamps
    end
  end
end
