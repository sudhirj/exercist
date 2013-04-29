class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.references :site
      t.string :title
      t.string :path
      t.integer :status
      t.integer :response_time
      t.timestamps
    end
  end
end
