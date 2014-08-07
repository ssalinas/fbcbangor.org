class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string :page
      t.string :section
      t.text :content
      t.string :image_src

      t.timestamps
    end
  end
end
