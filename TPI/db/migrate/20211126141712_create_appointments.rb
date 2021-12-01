class CreateAppointments < ActiveRecord::Migration[6.1]
  def change
    create_table :appointments do |t|
      t.belongs_to :professional, null: false, foreign_key: true
      t.datetime :date, null: false
      t.string :surname, null: false
      t.string :name, null: false
      t.integer :phone, null: false
      t.string :note

      t.timestamps
    end
    # cómo hago el index completo?
  end
end
