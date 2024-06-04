class CreateAnnouncements < ActiveRecord::Migration[7.1]
  def change
    create_table :announcements do |t|
      t.references :user, null: false, foreign_key: true
      t.string :description
      t.string :status

      t.timestamps
    end
  end
end
