require 'foreman-tasks'

class AddWindowState < ActiveRecord::Migration[6.0]
  
  class Window < ActiveRecord::Base
    self.table_name = 'foreman_patch_windows'
    belongs_to :task, class_name: 'ForemanTasks::Task'
  end

  def up
    add_column :foreman_patch_windows, :state, :string, default: 'planned', null: false
    add_index :foreman_patch_windows, :state, name: :index_foreman_patch_windows_on_state

    Window.all.each do |window|
      if window.task.nil?
        next if window.start_at > Time.current

        window.state = 'success'
      else
        case window.task.state
        when 'scheduled'
          window.state = window.task.state
        when 'pending','planning','planned','running'
          window.state = 'running'
        else
          window.state = window.task.result
        end
      end
      window.save!
    end
  end

  def down
    remove_index :foreman_patch_windows, :state, name: :index_foreman_patch_windows_on_state
    remove_column :foreman_patch_windows, :state
  end
end
