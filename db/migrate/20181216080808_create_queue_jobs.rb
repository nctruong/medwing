class CreateQueueJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :queue_jobs do |t|
      t.json :job_info

      t.timestamps
    end
  end
end
