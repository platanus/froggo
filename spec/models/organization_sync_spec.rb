require 'rails_helper'

RSpec.describe OrganizationSync, type: :model do
  describe 'relationships' do
    it { should belong_to(:organization) }
  end

  describe 'aasm' do
    context '#execute' do
      it '#execute changes state from created to executing' do
        expect { subject.execute }.to change(subject, :state).from('created').to('executing')
      end

      context '#execute completed' do
        before do
          subject.execute
          subject.complete
        end

        it '#execute changes state from completed to executing' do
          expect { subject.execute }.to change(subject, :state).from('completed').to('executing')
        end
      end

      context '#execute failed' do
        before do
          subject.execute
          subject.fail
        end

        it '#execute changes state from failed to executing' do
          expect { subject.execute }.to change(subject, :state).from('failed').to('executing')
        end
      end
    end

    context '#fail' do
      before do
        subject.execute
      end
      it '#fail changes state from executing to failed' do
        expect { subject.fail }.to change(subject, :state).from('executing').to('failed')
      end
    end

    context '#complete' do
      before do
        subject.execute
      end
      it '#complete changes state from executing to completed' do
        expect { subject.complete }.to change(subject, :state).from('executing').to('completed')
      end
    end
  end
end
