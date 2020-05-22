require 'rails_helper'

RSpec.describe GithubAuthenticable do
  before do
    begin
      Object.send(:remove_const, :DummyController)
    rescue NameError
      # do nothing
    end

    class DummyController
      include GithubAuthenticable

      def cookies
        "cookies"
      end

      def redirect_to(path)
        path
      end

      def root_path
        '/'
      end
    end
  end

  let(:github_session) { double(valid?: valid) }
  subject { DummyController.new }

  describe "#authenticate_github_user" do
    before do
      expect(GithubSession).to receive(:new).with(subject.cookies).and_return(github_session)
    end

    context "with valid github session" do
      let(:valid) { true }

      before do
        expect(subject).not_to receive(:redirect_to)
      end

      it { expect(subject.authenticate_github_user).to eq(github_session) }
    end

    context "with invalid github session" do
      let(:valid) { false }

      before do
        expect(subject).to receive(:redirect_to).with("/").and_return(true)
      end

      it { expect(subject.authenticate_github_user).to be_nil }
    end
  end

  describe "#github_session" do
    let(:github_session) { double }

    before do
      expect(GithubSession).to receive(:new).with(subject.cookies).and_return(github_session)
    end

    it { expect(subject.github_session).to eq(github_session) }
  end
end
