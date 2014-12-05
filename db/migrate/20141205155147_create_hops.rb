class CreateHops < ActiveRecord::Migration
  def up
    create_table :hops do |t|
      t.text :name
      t.text :contry
      t.text :aa
    end
  end

  def down
    drop_table :hops
  end
end
