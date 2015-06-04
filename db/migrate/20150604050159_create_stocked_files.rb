class CreateStockedFiles < ActiveRecord::Migration
  def change
    create_table :stocked_files do |t|
      t.string :original_name
      t.string :hash

      t.timestamps null: false
    end
  end
end
