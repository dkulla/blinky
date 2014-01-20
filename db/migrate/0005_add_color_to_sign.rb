class AddColorToSign < ActiveRecord::Migration
  def change
    add_column :signs, :color, :string
    add_column :signs, :background_color, :string
  end
end
