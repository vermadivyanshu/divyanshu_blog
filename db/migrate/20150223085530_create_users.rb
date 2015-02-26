class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :email
    	t.string :password_digest
    	t.string :role, :default => "blogger"
    	t.boolean :show_permission, :default => false
    	t.boolean :edit_permission, :default => false
    	t.boolean :delete_permission, :default => false
    	t.boolean :comment_permission, :default => false
    	t.boolean :index_permission, :default => true

      t.timestamps null: false
    end
  end
end
