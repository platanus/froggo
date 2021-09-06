ActiveAdmin.register AssignationMetric do
  permit_params :from, :github_user_id, :pull_request_id
  filter :created_at
  filter :from, as: :select, collection: AssignationMetric.froms
end
