class CreateOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :options do |t|
      t.references :optionable, polymorphic: true, null: false
      t.string :name

      t.timestamps
    end
  end
end
