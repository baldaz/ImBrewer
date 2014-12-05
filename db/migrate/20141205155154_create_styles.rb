class CreateStyles < ActiveRecord::Migration
  def up
    create_table :styles do |t|
      t.text :name
      t.integer :og
      t.integer :fg
      t.integer :ibu
      t.float :abv
    end
    Styles.create(name: 'IPA', og: 1053, fg: 1012, ibu: 21, abv: 4.6)
  end

  def down
    drop_table :styles
  end
end
