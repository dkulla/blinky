class AddFadeTimeToSign < ActiveRecord::Migration
  def change
    add_column :signs, :fade_time, :float
  end
end
