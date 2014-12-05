class CreateRecipes < ActiveRecord::Migration
  def up
    create_table :recipes do |t|
      t.text :name
      t.text :style
      t.integer :og
      t.integer :fg
      t.integer :ibu
      t.float :abv
      t.integer :batch
      t.integer :btime
      t.boolean :dhop
      t.timestamps
    end
  end

  def down
    drop_table :recipes
  end
end
