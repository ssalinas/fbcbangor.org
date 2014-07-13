class CreateCarouselImages < ActiveRecord::Migration
  def change
    create_table :carousel_images do |t|
      t.string :url
      t.string :caption

      t.timestamps
    end
  end
end
