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
        let(:form_performance) { Form::Performance.new(
          HashWithIndifferentAccess.new(
            FactoryGirl.build(:youtube_with_perf).wave_to_hash
          )
        ) }
        specify 'instantiates wave virtual attribute' do
          expect(form_performance.wave).to_not eq(nil)
        end
      end
    end
    describe '.process' do
      context 'returns false due to' do
        before do
          Youtube.any_instance.stub(:fill_site_info)
          Youtube.any_instance.stub(:save) { true }
        end
        let!(:youtube) { FactoryGirl.create(:youtube_with_perf) }
        let(:form_performance) { Form::Performance.new(
          HashWithIndifferentAccess.new(youtube.wave_to_hash)
        ) }
        specify 'no changes' do
          form_performance.process
          expect(form_performance.errors).to have_key(:no_changes)
        end
        specify 'timestamp conflict' do
          form_performance.incoming[:timestamp] = nil
          form_performance.process
          expect(form_performance.errors).to have_key(:conflicted)
        end
        specify 'empty parameters' do
          form_performance.incoming[:p] = { }
          form_performance.process
          expect(form_performance.errors).to have_key(:empty)
        end
      end
      context 'for new wave with valid parameters' do
        before do
          Youtube.any_instance.stub(:fill_site_info)
        end
        let!(:youtube) do
          youtube = FactoryGirl.build(
            :youtube_with_perf,
            perf: [{ a: 2, c: 2 }, { a: 3, c: 3 }]
          )
          # Repeated submission.
          youtube.performances[1].artists[0] = youtube.performances[0].artists[0]
          youtube.performances[1].compositions[0] = youtube.performances[0].compositions[0]
          # Existing submission.
          youtube.performances[1].artists[1] = FactoryGirl.create(:artist)
          youtube.performances[1].compositions[1] = FactoryGirl.create(:composition)
          youtube
        end
        let!(:form_performance) { Form::Performance.new(youtube.wave_to_hash) }
        before { form_performance.wave.channel_id = 'channel_id' }
        specify 'creates a Youtube record' do
          expect { form_performance.process }.to change(Youtube, :count).by(1)
        end
        specify 'creates Artist records' do
          expect { form_performance.process }.to change(Artist, :count).by(3)
        end
        specify 'creates Composition records' do
          expect { form_performance.process }.to change(Composition, :count).by(3)
        end
        specify 'creates Performance records' do
          expect { form_performance.process }.to change(Performance, :count).by(2)
        end
        describe 'after being called' do
          before { form_performance.process }
          let(:wave) { form_performance.wave }
          specify 'assigns associations correctly' do
            expect(wave.performances[1].artists[0]).to eq(wave.performances[0].artists[0])
            expect(wave.performances[1].compositions[0]).to eq(wave.performances[0].compositions[0])
          end
        end
      end
      context 'for existing wave with valid parameters' do
        before do
          Youtube.any_instance.stub(:fill_site_info)
        end
        let!(:existing_youtube) { FactoryGirl.create(:youtube_with_perf) }
        let!(:youtube) { FactoryGirl.build(
          :youtube_with_perf,
          video_id: existing_youtube.video_id
        ) }
        let!(:form_performance) { Form::Performance.new(youtube.wave_to_hash) }
        specify 'does not create a Youtube record' do
          expect { form_performance.process }.to_not change(Youtube, :count)
        end
      end
    end
  end
end
