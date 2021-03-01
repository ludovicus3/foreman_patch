class AddPatchTemplateToGroup < ActiveRecord::Migration[6.0]
  def change
    add_column :foreman_patch_groups, :template_id, :integer

    add_foreign_key :foreman_patch_groups, :templates, column: :template_id, name: :foreman_patch_groups_template_id_fk
  end
end
