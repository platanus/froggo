require 'rails_helper'

describe HookService do
  let (:admin_user) { double }
  let (:repository) { double(id: 5) }
  let (:hook) { create(:hook) }

  def build
    described_class.new(user: admin_user)
  end

  before do
    allow(admin_user).to receive(:token).and_return('thisistoken')
  end

  context "suscribe" do
    # it "to an existent hook should call edit" do
    #   hook.repository_id = 5
    #   expect(HookService).to receive(:subscribe).with(repository)
    # end

    # it "to a new hook should call create" do
    #   hook.id = 9
    #   expect(HookService).to receive(:subscribe).with(hook)
    # end
  end

  context "unsubscribe" do
    # it "to an existen hooks should call edit"
    # end

    # it "to an inexistent hook should fail"
    # end
  end

  context "create_new_hook" do
    # it "should make a request to octokit create_hook" do
    # end
  end

  context "edit_active_hook" do
    # it "should change hooks status" do
    # end

    # it "should make a request to octokit edit_hook" do
    # end
  end

  context "create" do
    # it "should create a hook"
    # end
  end
end
