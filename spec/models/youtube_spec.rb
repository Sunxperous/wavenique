require 'spec_helper'

describe Youtube do
=begin
  # Sample of mock Youtube model data.
    let(:youtube) { FactoryGirl.build(
      :youtube_with_perf,
      perf: [
        { :a => 3, :c => 3 },
        { :a => 2, :c => 1 }  
      ]
    ) }
=end

  def to_params(youtube, keys = {})
    params = { :perf => {} }
    params.merge!(keys)
    perf_index = 0
    youtube.performances.each do |perf|
      perf_hash = { "comp" => {}, "artist" => {} }
      artist_index = comp_index = 0
      perf.artists.each do |a|
        perf_hash["artist"][artist_index += 1] = { "n" => a.name, "id" => a.id }
      end
      perf.compositions.each do |c|
        perf_hash["comp"][comp_index += 1] = { "t" => c.title, "id" => c.id }
      end
      params[:perf][perf_index += 1] = perf_hash
    end
    params
  end

  shared_examples 'changes model counts' do |h|
    h[:y] == 0 ? (it { should_not change { Youtube.count } }) :
    (it { should change { Youtube.count }.by(h[:y]) })
    h[:p] == 0 ? (it { should_not change { Performance.count } }) :
    (it { should change { Performance.count }.by(h[:p]) })
    h[:c] == 0 ? (it { should_not change { Composition.count } }) :
    (it { should change { Composition.count }.by(h[:c]) })
    h[:a] == 0 ? (it { should_not change { Artist.count } }) :
    (it { should change { Artist.count }.by(h[:a]) })
  end 

  before do
    # Stub API-calling methods.
    Youtube.any_instance.stub(:fill_youtube_particulars) { true }
  end
	it { should respond_to(:video_id) }
  it { should respond_to(:channel) }
  it { should respond_to(:new_content) }
  it { should respond_to(:api_data) }
  it { should respond_to(:modify) }
	it { should have_many(:performances) }
	it { should validate_presence_of(:performances) }
	it { should validate_presence_of(:video_id) }
  it { should validate_presence_of(:channel_id) }
	it { should validate_uniqueness_of(:video_id) }
	it { should_not allow_value('qwerty').for(:video_id) }
	it { should_not allow_value('qwertyqwerty').for(:video_id) }
	it { should allow_value('qwerty12345').for(:video_id) }

  context 'instance methods' do
    describe '::modify' do
      context 'for a new Youtube video' do
        let(:youtube) { FactoryGirl.build(
          :youtube, video_id: new_youtube.video_id)
        }
        let!(:existing_youtube) { FactoryGirl.create(
          :youtube_with_perf,
          perf: [{ a: 2, c: 2 }, { a: 3, c: 3 }]
        ) }
        subject(:modify) { -> { youtube.modify(to_params(new_youtube)) } }
        context 'with 1a1c' do
          let(:new_youtube) { FactoryGirl.build(
            :youtube_with_perf,
            perf: [{ a: 1, c: 1 }]
          ) }
          include_examples 'changes model counts', y: 1, p: 1, c: 1, a: 1
          specify 'is valid' do
            modify.call
            youtube.should be_valid
          end
        end
        context 'with 2a2c' do
          let(:new_youtube) { FactoryGirl.build(
            :youtube_with_perf,
            perf: [{ a: 2, c: 2 }]
          ) }
          include_examples 'changes model counts', y: 1, p: 1, c: 2, a: 2
          specify 'is valid' do
            modify.call
            youtube.should be_valid
          end
        end
        context 'with 1a1c, 2a2c' do
          let(:new_youtube) { FactoryGirl.build(
            :youtube_with_perf,
            perf: [{ a: 1, c: 1 }, { a: 2, c: 2 }]
          ) }
          include_examples 'changes model counts', y: 1, p: 2, c: 3, a: 3
          specify 'is valid' do
            modify.call
            youtube.should be_valid
          end
        end
        context 'with 1a1c, 1a1c (repeated)' do
          let(:new_youtube) { FactoryGirl.build(
            :youtube_with_perf,
            perf: [{ a: 1, c: 1 }, { a: 1, c: 1 }]
          ) }
          before { new_youtube.performances[1] = new_youtube.performances[0] }
          include_examples 'changes model counts', y: 1, p: 2, c: 1, a: 1
          specify 'is valid' do
            modify.call
            youtube.should be_valid
          end
        end
        context 'with 0a0c' do
          let(:new_youtube) { FactoryGirl.build(
            :youtube_with_perf,
            perf: [{ a: 0, c: 0 }]
          ) }
          include_examples 'changes model counts', y: 0, p: 0, c: 0, a: 0
          specify 'will have errors' do
            modify.call
            youtube.should have(1).error_on(:performances)
          end
        end
        context 'with 1a1c (existing)' do
          let(:new_youtube) { FactoryGirl.build(
            :youtube_with_perf,
            perf: [{ a: 1, c: 1 }]
          ) }
          before {
            new_youtube.performances[0].artists[0] = existing_youtube.performances[0].artists[1]
            new_youtube.performances[0].compositions[0] = existing_youtube.performances[1].compositions[1]
          }
          include_examples 'changes model counts', y: 1, p: 1, c: 0, a: 0
          specify 'is valid' do
            modify.call
            youtube.should be_valid
          end
        end
        context 'with 2a2c (existing), 3a3c (existing)' do
          let(:new_youtube) { existing_youtube }
          before { new_youtube.video_id = 'poiuytrewq-' }
          include_examples 'changes model counts', y: 1, p: 2, c: 0, a: 0
          specify 'is valid' do
            modify.call
            youtube.should be_valid
          end
        end
      end

      context 'for an existing 1a1c Youtube video' do
        let!(:youtube) { FactoryGirl.create(
          :youtube_with_perf,
          perf: [{ a: 1, c: 1 }]
        ) }
        let!(:existing_youtube) { FactoryGirl.create(
          :youtube_with_perf,
          perf: [{ a: 2, c: 2 }, { a: 3, c: 3 }]
        ) }
        context 'with 1a1c' do
          let(:new_youtube) { FactoryGirl.build(
            :youtube_with_perf,
            perf: [{ a: 1, c: 1 }]
          ) }
          subject(:modify) { -> { youtube.modify(to_params(
            new_youtube,
            timestamp: youtube.updated_at.to_s
          )) } }
          include_examples 'changes model counts', y: 0, p: 0, c: 1, a: 1
          it { should_not change { youtube.performances.dup } }
          it { should change { youtube.performances[0].artists.dup } }
          it { should change { youtube.performances[0].compositions.dup } }
          specify 'is valid' do
            modify.call
            youtube.should be_valid
          end
        end
        context 'with 1a1c and invalid timestamp' do
          let(:new_youtube) { FactoryGirl.build(
            :youtube_with_perf,
            perf: [{ a: 1, c: 1 }]
          ) }
          subject(:modify) { -> { youtube.modify(to_params(new_youtube)) } }
          include_examples 'changes model counts', y: 0, p: 0, c: 0, a: 0
          it { should_not change { youtube.performances.dup } }
          it { should_not change { youtube.performances[0].artists.dup } }
          it { should_not change { youtube.performances[0].compositions.dup } }
          specify 'is not accepted' do
            modify.call
            youtube.should have(1).errors
            youtube.errors[:base].should include('Someone else has edited.')
          end
        end
        context 'with unchanged 1a1c' do
          subject(:modify) { -> { youtube.modify(to_params(
            youtube,
            timestamp: youtube.updated_at.to_s
          )) } }
          include_examples 'changes model counts', y: 0, p: 0, c: 0, a: 0
          it { should_not change { youtube.performances.dup } }
          it { should_not change { youtube.performances[0].artists.dup } }
          it { should_not change { youtube.performances[0].compositions.dup } }
          specify 'is not accepted' do
            modify.call
            youtube.should have(1).errors
            youtube.errors[:base].should include('There are no changes.')
          end
        end
        context 'with 2a2c' do
          let(:new_youtube) { FactoryGirl.build(
            :youtube_with_perf,
            perf: [{ a: 2, c: 2 }]
          ) }
          subject(:modify) { -> { youtube.modify(to_params(
            new_youtube,
            timestamp: youtube.updated_at.to_s
          )) } }
          include_examples 'changes model counts', y: 0, p: 0, c: 2, a: 2
          it { should_not change { youtube.performances.dup } }
          it { should change { youtube.performances[0].artists.dup } }
          it { should change { youtube.performances[0].compositions.dup } }
          specify 'is valid' do
            modify.call
            youtube.should be_valid
          end
        end
        context 'with 2a2c, 3a3c (1a1c repeated)' do
          let(:new_youtube) { FactoryGirl.build(
            :youtube_with_perf,
            perf: [{ a: 2, c: 2 }, { a: 3, c: 3 }]
          ) }
          before {
            new_youtube.performances[1].artists[0] = new_youtube.performances[0].artists[0]
            new_youtube.performances[1].compositions[1] = new_youtube.performances[0].compositions[1]
          }
          subject(:modify) { -> { youtube.modify(to_params(
            new_youtube,
            timestamp: youtube.updated_at.to_s
          )) } }
          include_examples 'changes model counts', y: 0, p: 1, c: 4, a: 4
          it { should change { youtube.performances.dup } }
          it { should change { youtube.performances[0].artists.dup } }
          it { should change { youtube.performances[0].compositions.dup } }
          specify 'is valid' do
            modify.call
            youtube.should be_valid
          end
        end
        context 'with 2a2c (existing), 3a3c (existing)' do
          subject(:modify) { -> { youtube.modify(to_params(
            existing_youtube,
            timestamp: youtube.updated_at.to_s
          )) } }
          include_examples 'changes model counts', y: 0, p: 1, c: 0, a: 0
          it { should change { youtube.performances.dup } }
          it { should change { youtube.performances[0].artists.dup } }
          it { should change { youtube.performances[0].compositions.dup } }
          specify 'is valid' do
            modify.call
            youtube.should be_valid
          end
        end
      end
    end
  end
end
