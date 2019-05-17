require 'rails_helper'

describe SlackCommandsService do
  def build(*_args)
    described_class.new(*_args)
  end

  let(:service) { build(params: params) }
  let(:github_user) { create(:github_user, login: 'isidoravs') }
  let(:organization) { create(:organization, login: 'platanus') }
  let(:recommendations) do
    {
      best: [
        create(:github_user, login: 'blackjid'),
        create(:github_user, login: 'gmq'),
        create(:github_user, login: 'iobaixas')
      ]
    }
  end
  let(:statistics) { { obedient: 1, indifferent: 0, rebel: 2 } }
  let(:statistics_count) { { obedient_count: 1, indifferent_count: 0, rebel_count: 2 } }

  before do
    allow(GetRecommendations).to receive(:for)
      .with(github_user: github_user,
            organization: organization)
      .and_return(recommendations)

    allow(ComputeUserStatistics).to receive(:for)
      .with(github_user_id: github_user.id,
            organization_id: organization.id)
      .and_return(statistics)

    allow(I18n).to receive(:t)
      .with('messages.slack.recommended_users', users: 'blackjid, gmq, iobaixas')
      .and_return('Asigna tu próximo PR a blackjid, gmq, iobaixas')

    allow(I18n).to receive(:t)
      .with('messages.slack.hello')
      .and_return('croak!')

    allow(I18n).to receive(:t)
      .with('messages.slack.next_pr_wrong_params')
      .and_return('Avíspate')

    allow(I18n).to receive(:t)
      .with('messages.slack.no_recommendations')
      .and_return('No puedes ver esto')

    allow(I18n).to receive(:t)
      .with('messages.slack.summary', **statistics_count)
      .and_return('Puntos: 1 obediencia, 0 indiferencia, 2 rebeldía')

    allow(I18n).to receive(:t)
      .with('messages.slack.summary_wrong_params')
      .and_return('Avíspate')
  end

  context 'command is /froggo' do
    let(:params) { { 'command' => '/froggo' } }

    it { expect(service.reply).to eq('croak!') }
  end

  context 'command is /next_pr and params are correct' do
    let(:params) { { 'command' => '/next_pr', 'text' => 'isidoravs platanus' } }

    let!(:membership) do
      create(:organization_membership, github_user_id: github_user.id,
                                       organization_id: organization.id,
                                       is_member_of_default_team: true)
    end

    it { expect(service.reply).to eq('Asigna tu próximo PR a blackjid, gmq, iobaixas') }
  end

  context 'command is /next_pr and there\'s no organization' do
    let(:params) { { 'command' => '/next_pr', 'text' => 'isidoravs' } }

    it { expect(service.reply).to eq('Avíspate') }
  end

  context 'command is /next_pr and there\'s no content' do
    let(:params) { { 'command' => '/next_pr', 'text' => '' } }

    it { expect(service.reply).to eq('Avíspate') }
  end

  context 'command is /next_pr and organization doesn\'t exist' do
    let(:params) { { 'command' => '/next_pr', 'text' => 'isidoravs bananus' } }

    it { expect(service.reply).to eq('Avíspate') }
  end

  context 'command is /next_pr and user doesn\'t exist' do
    let(:params) { { 'command' => '/next_pr', 'text' => 'billgates platanus' } }

    it { expect(service.reply).to eq('Avíspate') }
  end

  context 'command is /next_pr and user doesn\'t belong to default team' do
    let(:params) { { 'command' => '/next_pr', 'text' => 'isidoravs platanus' } }

    let!(:membership) do
      create(:organization_membership, github_user_id: github_user.id,
                                       organization_id: organization.id,
                                       is_member_of_default_team: false)
    end

    it { expect(service.reply).to eq('No puedes ver esto') }
  end

  context 'command is /next_pr and user doesn\'t belong to organization' do
    let(:params) { { 'command' => '/next_pr', 'text' => 'isidoravs budacom' } }
    let(:organization) { create(:organization, login: 'budacom') }

    it { expect(service.reply).to eq('No puedes ver esto') }
  end

  context 'command is /summary and params are correct' do
    let(:params) { { 'command' => '/summary', 'text' => 'isidoravs platanus' } }
    let!(:membership) do
      create(:organization_membership, github_user_id: github_user.id,
                                       organization_id: organization.id,
                                       is_member_of_default_team: true)
    end

    it { expect(service.reply).to eq('Puntos: 1 obediencia, 0 indiferencia, 2 rebeldía') }
  end

  context 'command is /summary and there\'s no organization' do
    let(:params) { { 'command' => '/summary', 'text' => 'isidoravs' } }

    it { expect(service.reply).to eq('Avíspate') }
  end

  context 'command is /summary and there\'s no content' do
    let(:params) { { 'command' => '/summary', 'text' => '' } }

    it { expect(service.reply).to eq('Avíspate') }
  end

  context 'command is /summary and organization doesn\'t exist' do
    let(:params) { { 'command' => '/summary', 'text' => 'isidoravs bananus' } }

    it { expect(service.reply).to eq('Avíspate') }
  end

  context 'command is /summary and user doesn\'t exist' do
    let(:params) { { 'command' => '/summary', 'text' => 'billgates platanus' } }

    it { expect(service.reply).to eq('Avíspate') }
  end

  context 'command is /summary and user doesn\'t belong to default team' do
    let(:params) { { 'command' => '/summary', 'text' => 'isidoravs platanus' } }
    let!(:membership) do
      create(:organization_membership, github_user_id: github_user.id,
                                       organization_id: organization.id,
                                       is_member_of_default_team: false)
    end

    it { expect(service.reply).to eq('No puedes ver esto') }
  end

  context 'command is /summary and user doesn\'t belong to organization' do
    let(:params) { { 'command' => '/summary', 'text' => 'isidoravs budacom' } }
    let(:organization) { create(:organization, login: 'budacom') }

    it { expect(service.reply).to eq('No puedes ver esto') }
  end
end
