require 'spec_helper'

describe Form::Performance do
  context '#virtual attributes' do
    it { should respond_to(:wave) }
    it { should respond_to(:new_content) }
    it { should respond_to(:incoming) }
  end
  context '#methods' do
    describe '.initialize' do
      context 'with a wave' do
        let(:form_performance) { Form::Performance.new(
          wave: FactoryGirl.build(:youtube)
        )}
        specify 'instantiates wave virtual attribute' do
          expect(form_performance.wave).to_not eq(nil)
        end
        specify 'generates default performances for wave' do
          expect(form_performance.wave.performances.length).to eq(1)
        end
      end
      context 'with parameters' do
        let(:parameters) do
          parameters = HashWithIndifferentAccess.new(
            FactoryGirl.build(:youtube_with_perf).wave_to_hash
          )
        end
        let(:form_performance) { Form::Performance.new(parameters) }
        specify 'instantiates wave virtual attribute' do
          expect(form_performance.wave).to_not eq(nil)
        end
      end
    end
    describe '.process' do
      before do
        Youtube.any_instance.stub(:fill_site_info)
        Youtube.any_instance.stub(:save) { true }
      end
      let!(:youtube) { FactoryGirl.create(:youtube_with_perf) }
      let(:parameters) do
        parameters = HashWithIndifferentAccess.new(youtube.wave_to_hash)
      end
      let!(:form_performance) { Form::Performance.new(parameters) }
      specify 'returns false for no changes' do
        form_performance.process
        expect(form_performance.errors).to have_key(:no_changes)
      end
      specify 'returns false for timestamp conflict' do
        form_performance.incoming[:timestamp] = nil
        form_performance.process
        expect(form_performance.errors).to have_key(:conflicted)
      end
    end
  end
end
