class AddTempoToSign < ActiveRecord::Migration
  def change
    add_column :signs, :tempo, :float
  end
end
