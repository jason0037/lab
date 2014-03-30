class AddApplicantToLabEvalProjects < ActiveRecord::Migration
  def change
    add_column :lab_eval_projects,:applicant_id,:integer
    add_column :lab_eval_projects,:brief,:string
    add_column :lab_eval_projects,:status_log,:string
  end

  def down
    remove_column :applicant, :breif,:satus_log
  end
end
