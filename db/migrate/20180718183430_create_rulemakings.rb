class CreateRulemakings < ActiveRecord::Migration[5.1]
  def change
    create_table :rulemakings do |t|
      t.string :rulemaking_name
      t.string :agency
      t.boolean :active

      t.timestamps
    end
  end
end
