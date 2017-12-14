require 'rails_helper'

describe HookService do
  let (:admin_user) { double }
  let (:repository) { double(id: 5) }
  let (:hook) { create(:hook, id: 5) }

  def build
    described_class.new(user: admin_user)
  end

  before do
    allow(admin_user).to receive(:token).and_return('thisistoken')
  end

  context "suscribe" do
    it "suscribe a hook" do
    end
  end
end
