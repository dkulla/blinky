class AddColorToSign < ActiveRecord::Migration
  def change
    add_column :signs, :color, :string
  end
end
