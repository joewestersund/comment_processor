class CreateCommentDataSources < ActiveRecord::Migration[5.1]
  def change
    create_table :comment_data_sources do |t|
      t.string :data_source_name
      t.string :string
      t.string :description
      t.string :comment_download_url
      t.boolean :active

      t.timestamps
    end
  end
end
