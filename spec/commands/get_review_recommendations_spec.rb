require 'rails_helper'

describe GetReviewRecommendations do
  def perform(*args)
    described_class.for(*args)
  end

  def perform_with_predefined_args
    perform(
      github_user_id: github_user_id,
      other_users_ids: other_users_ids
    )
  end

  let(:requesting_user) { create(:github_user) }
  let(:other_user1) { create(:github_user, name: 'user1') }
  let(:other_user2) { create(:github_user, name: 'user2') }
  let(:other_user3) { create(:github_user, name: 'user3') }
  let(:other_user4) { create(:github_user, name: 'user4') }
  let(:other_user5) { create(:github_user, name: 'user5') }
  let(:other_user6) { create(:github_user, name: 'user6') }
  let(:other_user7) { create(:github_user, name: 'user7') }
  let(:github_user_id) { requesting_user.id }

  context 'without other users in the team' do
    let(:other_users_ids) { [] }

    it 'returns empty list of most recommended users' do
      expect(perform_with_predefined_args[:best]).to be_empty
    end

    it 'returns empty list of least recommended users' do
      expect(perform_with_predefined_args[:worst]).to be_empty
    end
  end

  context 'when 3 or less other users in the team' do
    let(:other_users_ids) { [other_user1.id, other_user2.id, other_user3.id] }

    it 'returns list with two of them as most recommended users' do
      recommended = perform_with_predefined_args[:best]
      expect(recommended.length).to eq(2)
      expect(other_users_ids).to include(*recommended.map { |user| user["id"] })
    end

    it 'returns a list with one least recommended user' do
      recommended = perform_with_predefined_args[:worst]
      expect(recommended.length).to eq(1)
      expect(other_users_ids).to include(*recommended.map { |user| user["id"] })
    end
  end

  context 'with more than 3 and less than 6 other users in the team' do
    let(:other_users_ids) do
      [other_user1.id, other_user2.id, other_user3.id, other_user4.id]
    end

    context 'with no previous review requests' do
      it 'returns list with 3 users as most recommended users' do
        expect(perform_with_predefined_args[:best].map { |user| user["id"] })
          .to contain_exactly(other_user1.id, other_user2.id, other_user3.id)
      end

      it 'returns list with remaining users as least recommended users' do
        expect(perform_with_predefined_args[:worst].map { |user| user["id"] })
          .to contain_exactly(other_user4.id)
      end
    end

    context 'with previous review requests' do
      let!(:pull_request_1) do
        create(
          :pull_request_relation,
          github_user_id: other_user1.id,
          target_user_id: github_user_id
        )
      end

      it 'returns list with 3 users with least requests as most recommended' do
        expect(perform_with_predefined_args[:best].map { |user| user["id"] })
          .to contain_exactly(other_user2.id, other_user3.id, other_user4.id)
      end

      it 'returns list with remaining users as least recommended' do
        expect(perform_with_predefined_args[:worst].map { |user| user["id"] })
          .to contain_exactly(other_user1.id)
      end
    end
  end

  context 'with more than 6 other users in the team' do
    let(:other_users_ids) do
      [
        other_user1.id, other_user2.id, other_user3.id, other_user4.id,
        other_user5.id, other_user6.id, other_user7.id
      ]
    end

    context 'with no previous review requests' do
      it 'returns list with 3 users as most recommended users' do
        expect(perform_with_predefined_args[:best].map { |user| user["id"] })
          .to contain_exactly(other_user1.id, other_user2.id, other_user3.id)
      end

      it 'returns list with 3 users as least recommended users' do
        expect(perform_with_predefined_args[:worst].map { |user| user["id"] })
          .to contain_exactly(other_user5.id, other_user6.id, other_user7.id)
      end
    end

    context 'with previous review requests' do
      let!(:pull_request_1) do
        create(
          :pull_request_relation,
          github_user_id: other_user1.id,
          target_user_id: github_user_id
        )
      end
      let!(:pull_request_2) do
        create(
          :pull_request_relation,
          github_user_id: other_user3.id,
          target_user_id: github_user_id
        )
      end
      let!(:pull_request_3) do
        create(
          :pull_request_relation,
          github_user_id: other_user4.id,
          target_user_id: github_user_id
        )
      end

      it 'returns list with 3 users with least requests as most recommended' do
        expect(perform_with_predefined_args[:best].map { |user| user["id"] })
          .to contain_exactly(other_user2.id, other_user5.id, other_user6.id)
      end

      it 'returns list with 3 users with most requests as least recommended' do
        expect(perform_with_predefined_args[:worst].map { |user| user["id"] })
          .to contain_exactly(other_user1.id, other_user3.id, other_user4.id)
      end
    end
  end
end
