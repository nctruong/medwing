class CreateWorkerMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :worker_messages do |t|
      t.string :worker
      t.string :message
      t.string :error_message
      t.boolean :error, default: true

      t.timestamps
    end
  end
end
