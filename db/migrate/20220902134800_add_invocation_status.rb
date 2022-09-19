require 'foreman-tasks'

class AddInvocationStatus < ActiveRecord::Migration[6.0]
  class Invocation < ActiveRecord::Base
    self.table_name = 'foreman_patch_invocations'
    belongs_to :task, class_name: 'ForemanTasks::Task'
  end

  def up
    add_column :foreman_patch_invocations, :status, :string, default: 'planned', null: false
    add_index :foreman_patch_invocations, :status, name: :foreman_patch_invocations_by_status

    Invocation.all.each do |invocation|
      if invocation.task.nil?
        next if invocation.task_id.nil?

        invocation.update!(status: 'success')
      else
        invocation.update!(status: invocation.task.result)
      end
    end
  end

  def down
    remove_index :foreman_patch_invocations, :status, name: :foreman_patch_invocations_by_status
    remove_column :foreman_patch_invocations, :status
  end
end
