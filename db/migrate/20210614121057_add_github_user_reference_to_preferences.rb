class AddGithubUserReferenceToPreferences < ActiveRecord::Migration[6.0]
  def change
   safety_assured { add_reference :preferences, :github_user, foreign_key: true }
  end
end
