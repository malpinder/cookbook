class CreateAmounts < ActiveRecord::Migration
  def self.up
    create_table :amounts do |t|
      t.references :recipe
      t.references :ingredient

      t.string :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :amounts
  end
end
