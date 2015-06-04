class RemoveHashFromStockedFiles < ActiveRecord::Migration
  def change
    remove_column :stocked_files, :hash, :string
  end
end
