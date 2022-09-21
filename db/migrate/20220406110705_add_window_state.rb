require 'foreman-tasks'

class AddWindowState < ActiveRecord::Migration[6.0]
  
  class Window < ActiveRecord::Base
    self.table_name = 'foreman_patch_windows'
    belongs_to :task, class_name: 'ForemanTasks::Task'
  end

  def up
    add_column :foreman_patch_windows, :status, :string, default: 'planned', null: false
    add_index :foreman_patch_windows, :status, name: :index_foreman_patch_windows_on_status

    Window.all.each do |window|
      if window.task.nil?
        window.status = 'completed' unless window.task_id.nil?
      else
        case window.task.state
        when 'scheduled'
          window.status = window.task.state
        when 'pending','planning','planned','running'
          window.status = 'running'
        when 'stopped'
          window.status = 'completed'
        else
          window.status = window.task.state
        end
      end
      window.save!
    end
  end

  def down
    remove_index :foreman_patch_windows, :status, name: :index_foreman_patch_windows_on_status
    remove_column :foreman_patch_windows, :status
  end
end
