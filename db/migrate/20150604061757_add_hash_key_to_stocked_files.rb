class AddHashKeyToStockedFiles < ActiveRecord::Migration
  def change
    add_column :stocked_files, :hash_key, :string
  end
end
