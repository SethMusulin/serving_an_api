class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.string :color
      t.integer :doors
      t.integer :make_id
      t.date :purchased_on
      t.timestamps
    end
    add_index :cars, :make_id
  end
end
