class CreateDigitals < ActiveRecord::Migration[6.0]
  def change
    create_table :digitals do |t|

      t.timestamps
    end
  end
end
