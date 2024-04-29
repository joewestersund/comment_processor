class AddDataChangedAtToRulemakings < ActiveRecord::Migration[7.0]
  def change
    add_column :rulemakings, :data_changed_at, :datetime

    # fill in a default value based on the change log entries to date
    reversible do |dir|
      dir.up do
        #Rulemaking.connection.schema_cache.clear!
        Rulemaking.reset_column_information
        Rulemaking.all.each do |r|
          r.data_changed_at = r.change_log_entries.maximum(:updated_at)
          if r.data_changed_at.nil?
            # there are no change log entries.
            r.data_changed_at = r.updated_at
          end
          r.save
        end
      end
    end
  end
end
