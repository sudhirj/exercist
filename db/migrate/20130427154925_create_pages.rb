class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.references :site
      t.string :title
      t.string :url
      t.integer :status
      t.decimal :response_time
      t.timestamps
    end
  end
end
