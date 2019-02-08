require 'rails_helper'

describe GithubUserService do
  let!(:gh_user) { create(:github_user) }
  let (:user1) do
    double(login: 'a user',
           id: '3',
           avatar_url: '',
           html_url: '',
           email: '',
           name: '')
  end

  let (:user2) do
    double(login: 'a user',
           id: gh_user.gh_id,
           avatar_url: '',
           html_url: '',
           email: '',
           name: '')
  end

  def build(*_args)
    described_class.new(*_args)
  end

  context 'find_or_create' do
    it 'create a new GithubUser in BD' do
      expect { build.find_or_create(user1) }
        .to change { GithubUser.all.count }.by(1)
    end

    it 'find an existing user in BD' do
      find = build.find_or_create(user2)
      expect(find).to eq(gh_user)
    end
  end
end
