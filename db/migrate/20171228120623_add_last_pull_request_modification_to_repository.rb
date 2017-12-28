class AddLastPullRequestModificationToRepository < ActiveRecord::Migration[5.1]
  def change
    add_column :repositories, :last_pull_request_modification, :datetime
    Repository.reset_column_information
    Repository.all.each do |repo|
      if repo.pull_requests.present?
        repo.update!(last_pull_request_modification: repo.pull_requests.last.updated_at)
      else
        repo.update!(last_pull_request_modification: repo.created_at)
      end
    end
  end
end
