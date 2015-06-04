class AddColumnToStockedFile < ActiveRecord::Migration
  def change
    add_column :stocked_files, :size, :int
  end
end
