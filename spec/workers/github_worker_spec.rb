require 'rails_helper'
RSpec.describe GithubWorker, type: :worker do
  # describe "FETCH_ORG_REPOS" do
  #   let(:organization) { create(:organization) }

  #   before do
  #     allow_any_instance_of(GithubService).to receive(:create_organization_repositories)
  #       .with(organization.name).and_return(nil)
  #   end

  #   before :each do
  #     Sidekiq::Worker.clear_all
  #   end

  #   it "adds worker to queue" do
  #     expect do
  #       GithubWorker.perform_async("FETCH_ORG_REPOS", organization_id: organization.id)
  #     end.to change(GithubWorker.jobs, :size).by(1)
  #   end

  #   it "calls GithubService" do
  #     expect_any_instance_of(GithubService).to(
  #       receive(:create_organization_repositories)
  #     )

  #     GithubWorker.perform_async("FETCH_ORG_REPOS", organization_id: organization.id)
  #     GithubWorker.drain
  #   end
  # end

  # describe 'FETCH_REPOS_PULL_REQUEST' do
  #   let(:owner) { double(id: 1, token: 'a token') }
  #   let!(:repository) { double(id: 1, full_name: 'platanus/repository') }

  #   before do
  #     allow_any_instance_of(GithubService).to receive(:create_repository_pull_requests)
  #       .with(repository.id, repository.full_name).and_return(nil)
  #     allow(AdminUser).to receive(:find).and_return(owner)
  #     allow(Repository).to receive(:find).and_return(repository)
  #   end

  #   before :each do
  #     Sidekiq::Worker.clear_all
  #   end

  #   it 'adds worker to queue' do
  #     expect do
  #       GithubWorker.perform_async(
  #         'FETCH_REPOS_PULL_REQUEST',
  #         owner_id: owner.id,
  #         repository_id: repository.id
  #       )
  #     end.to change(GithubWorker.jobs, :size).by(1)
  #   end

  #   it 'calls GithubService' do
  #     expect_any_instance_of(GithubService).to(
  #       receive(:create_repository_pull_requests)
  #     )

  #     GithubWorker.perform_async(
  #       'FETCH_REPOS_PULL_REQUEST',
  #       owner_id: owner.id,
  #       repository_id: repository.id
  #     )
  #     GithubWorker.drain
  #   end
  # end
end
