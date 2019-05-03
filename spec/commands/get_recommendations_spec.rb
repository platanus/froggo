require 'rails_helper'

describe GetRecommendations do
  def perform(*_args)
    described_class.for(*_args)
  end

  let(:requesting_user) { create(:github_user) }
  let(:organization) { create(:organization) }

  context 'with user within the organization' do
    let(:github_users_in_default_team) { create_list(:github_user, 3) }
    let(:github_users_not_in_default_team) { create_list(:github_user, 3) }
    let(:review_recommendations) { double(:review_recommendations) }

    before do
      create(:organization_membership, github_user_id: requesting_user.id,
                                       organization_id: organization.id,
                                       is_member_of_default_team: true)

      github_users_in_default_team.each do |github_user|
        create(:organization_membership, github_user_id: github_user.id,
                                         organization_id: organization.id,
                                         is_member_of_default_team: true)
      end

      github_users_not_in_default_team.each do |github_user|
        create(:organization_membership, github_user_id: github_user.id,
                                         organization_id: organization.id,
                                         is_member_of_default_team: false)
      end

      allow(GetReviewRecommendations).to receive(:for)
        .with(github_user_id: requesting_user.id,
              other_users_ids: github_users_in_default_team.pluck(:id))
        .and_return(review_recommendations)
    end

    it 'returns same recommendation as review recommendation' do
      expect(perform(github_user: requesting_user, organization: organization))
        .to eq(review_recommendations)
    end
  end

  context 'with user not within the organization' do
    it 'returns nil' do
      expect(perform(github_user: requesting_user, organization: organization))
        .to be_nil
    end
  end

  context 'with user not in default team' do
    before do
      create(:organization_membership, github_user_id: requesting_user.id,
                                       organization_id: organization.id,
                                       is_member_of_default_team: false)
    end

    it 'returns nil' do
      expect(perform(github_user: requesting_user, organization: organization))
        .to be_nil
    end
  end
end
