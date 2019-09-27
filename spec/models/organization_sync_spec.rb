require 'rails_helper'

RSpec.describe OrganizationSync, type: :model do
  subject(:sync) { described_class.new }

  describe 'relationships' do
    it { should belong_to(:organization) }
  end

  describe 'aasm' do
    context '#execute' do
      it '#execute changes state from created to executing' do
        expect { sync.execute }.to change{ sync.state }.from('created').to('executing')
      end

      context 'when execute completed' do
        before do
          sync.execute
          sync.complete
        end

        it '#execute changes state from completed to executing' do
          expect { sync.execute }.to change{ sync.state }.from('completed').to('executing')
        end
      end

      context 'when execute failed' do
        before do
          sync.execute
          sync.fail
        end

        it '#execute changes state from failed to executing' do
          expect { sync.execute }.to change{ sync.state }.from('failed').to('executing')
        end
      end
    end

    context '#fail' do
      before do
        sync.execute
      end
      it '#fail changes state from executing to failed' do
        expect { sync.fail }.to change{ sync.state }.from('executing').to('failed')
      end
    end

    context '#complete' do
      before do
        sync.execute
      end
      it '#complete changes state from executing to completed' do
        expect { sync.complete }.to change{ sync.state }.from('executing').to('completed')
      end
    end
  end
end
