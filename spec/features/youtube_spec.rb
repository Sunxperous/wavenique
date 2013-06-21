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

  shared_context 'changes model counts' do
    specify 'changes model counts' do
      actual_count = {
        youtube: Youtube.count,
        performance: Performance.count,
        artist: Artist.count,
        composition: Composition.count
      }
      expected_count = {
        youtube: count_of[:youtube] + h[:y],
        performance: count_of[:performance] + h[:p],
        artist: count_of[:artist] + h[:a],
        composition: count_of[:composition] + h[:c]
      }
      expect(expected_count).to eq(actual_count)
    end
  end 

  before do
    # Stub API-calling methods.
    Youtube.any_instance.stub(:fill_youtube_particulars) { true }
    Youtube.any_instance.stub(:retrieve_api_data) { true }
  end
  pending 'instance methods' do
    describe '::modify' do
      # Existing Youtube video for existing Artists, Compositions.
      let!(:existing_youtube) { FactoryGirl.create(
        :youtube_with_perf,
        perf: [{ a: 2, c: 2 }, { a: 3, c: 3 }]
      ) }
      context 'for a new Youtube video' do
        # New Youtube video.
        let(:youtube) { FactoryGirl.build(
          :youtube, video_id: new_youtube.video_id)
        }
        # Table counts after above initialised.
        let!(:count) { {
          youtube: Youtube.count,
          performance: Performance.count,
          artist: Artist.count,
          composition: Composition.count
        } }
        # Instance method ::modify is to be called.
        let(:modify) { -> { youtube.modify(to_params(new_youtube)) } }

        context 'with 1a1c' do
          let(:new_youtube) { FactoryGirl.build(
            :youtube_with_perf,
            perf: [{ a: 1, c: 1 }]
          ) }
          before { modify.call }
          include_context 'changes model counts' do
            let(:h) { { y: 1, p: 1, c: 1, a: 1 } }
            let(:count_of) { count }
          end
          specify 'is valid' do
            expect(youtube).to be_valid
          end
        end
        context 'with 2a2c' do
          let(:new_youtube) { FactoryGirl.build(
            :youtube_with_perf,
            perf: [{ a: 2, c: 2 }]
          ) }
          before { modify.call }
          include_context 'changes model counts' do
            let(:h) { { y: 1, p: 1, c: 2, a: 2 } }
            let(:count_of) { count }
          end
          specify 'is valid' do
            expect(youtube).to be_valid
          end
        end
        context 'with 1a1c, 2a2c' do
          let(:new_youtube) { FactoryGirl.build(
            :youtube_with_perf,
            perf: [{ a: 1, c: 1 }, { a: 2, c: 2 }]
          ) }
          before { modify.call }
          include_context 'changes model counts' do
            let(:h) { { y: 1, p: 2, c: 3, a: 3 } }
            let(:count_of) { count }
          end
          specify 'is valid' do
            expect(youtube).to be_valid
          end
        end
        context 'with 1a1c, 1a1c (repeated)' do
          let(:new_youtube) { FactoryGirl.build(
            :youtube_with_perf,
            perf: [{ a: 1, c: 1 }, { a: 1, c: 1 }]
          ) }
          before {
            new_youtube.performances[1] = new_youtube.performances[0]
            modify.call
          }
          include_context 'changes model counts' do
            let(:h) { { y: 1, p: 2, c: 1, a: 1 } }
            let(:count_of) { count }
          end
          specify 'is valid' do
            expect(youtube).to be_valid
          end
        end
        context 'with 0a0c' do
          let(:new_youtube) { FactoryGirl.build(
            :youtube_with_perf,
            perf: [{ a: 0, c: 0 }]
          ) }
          before { modify.call }
          include_context 'changes model counts' do
            let(:h) { { y: 0, p: 0, c: 0, a: 0 } }
            let(:count_of) { count }
          end
          specify 'will have errors' do
            expect(youtube).to have(1).error_on(:performances)
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
            modify.call
          }
          include_context 'changes model counts' do 
            let(:h) { { y: 1, p: 1, c: 0, a: 0 } }
            let(:count_of) { count }
          end
          specify 'is valid' do
            expect(youtube).to be_valid
          end
        end
        context 'with 2a2c (existing), 3a3c (existing)' do
          let(:new_youtube) { existing_youtube }
          before {
            new_youtube.video_id = 'poiuytrewq-'
            modify.call
          }
          include_context 'changes model counts' do
            let(:h) { { y: 1, p: 2, c: 0, a: 0 } }
            let(:count_of) { count }
          end
          specify 'is valid' do
            expect(youtube).to be_valid
          end
        end
      end

      context 'for an existing 1a1c, 2a2c Youtube video' do
        # Existing Youtube video.
        let!(:youtube) { FactoryGirl.create(
          :youtube_with_perf,
          perf: [{ a: 1, c: 1 }, { a: 2, c: 2 }]
        ) }
        # Table counts after above initialised.
        let!(:count) { {
          youtube: Youtube.count,
          performance: Performance.count,
          artist: Artist.count,
          composition: Composition.count
        } }
        # Youtube associations id.
        let!(:original_params) { to_params(youtube) }
        
        context 'with 1a1c' do
          let(:new_youtube) { FactoryGirl.build(
            :youtube_with_perf,
            perf: [{ a: 1, c: 1 }]
          ) }
          before { youtube.modify(to_params(
            new_youtube,
            timestamp: youtube.updated_at.to_s
          )) }
          include_context 'changes model counts' do
            let(:h) { { y: 0, p: 0, c: 1, a: 1 } }
            let(:count_of) { count }
          end
          specify 'changes associations' do
            expect(to_params(youtube)).to_not eq(original_params)
          end
          specify 'is valid' do
            expect(youtube).to be_valid
          end
        end
        context 'with 1a1c and invalid timestamp' do
          let(:new_youtube) { FactoryGirl.build(
            :youtube_with_perf,
            perf: [{ a: 1, c: 1 }]
          ) }
          before { youtube.modify(to_params(new_youtube)) }
          include_context 'changes model counts' do
            let(:h) { { y: 0, p: 0, c: 0, a: 0 } }
            let(:count_of) { count }
          end
          specify 'changes associations' do
            expect(to_params(youtube)).to eq(original_params)
          end
          specify 'is not accepted' do
            expect(youtube).to have(1).errors
            expect(youtube.errors[:base]).to include('Someone else has edited.')
          end
        end
        context 'with unchanged 1a1c, 2a2c' do
          before { youtube.modify(to_params(
            youtube,
            timestamp: youtube.updated_at.to_s
          )) } 
          include_context 'changes model counts' do
            let(:h) { { y: 0, p: 0, c: 0, a: 0 } }
            let(:count_of) { count }
          end
          specify 'changes associations' do
            expect(to_params(youtube)).to eq(original_params)
          end
          specify 'is not accepted' do
            expect(youtube).to have(1).errors
            expect(youtube.errors[:base]).to include('There are no changes.')
          end
        end
        context 'with 2a2c' do
          let(:new_youtube) { FactoryGirl.build(
            :youtube_with_perf,
            perf: [{ a: 2, c: 2 }]
          ) }
          before { youtube.modify(to_params(
            new_youtube,
            timestamp: youtube.updated_at.to_s
          )) }
          include_context 'changes model counts' do
            let(:h) { { y: 0, p: 0, c: 2, a: 2 } }
            let(:count_of) { count }
          end
          specify 'changes associations' do
            expect(to_params(youtube)).to_not eq(original_params)
          end
          specify 'is valid' do
            expect(youtube).to be_valid
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
            youtube.modify(to_params(
            new_youtube,
            timestamp: youtube.updated_at.to_s
          )) }
          include_context 'changes model counts' do
            let(:h) { { y: 0, p: 0, c: 4, a: 4 } }
            let(:count_of) { count }
          end
          specify 'changes associations' do
            expect(to_params(youtube)).to_not eq(original_params)
            expect(to_params(youtube)[:perf].count).to eq(
              original_params[:perf].count
            )
          end
          specify 'is valid' do
            expect(youtube).to be_valid
          end
        end
        context 'with 2a2c (existing), 3a3c (existing)' do
          before { youtube.modify(to_params(
            existing_youtube,
            timestamp: youtube.updated_at.to_s
          )) }
          include_context 'changes model counts' do
            let(:h) { { y: 0, p: 0, c: 0, a: 0 } }
            let(:count_of) { count }
          end
          specify 'changes associations' do
            expect(to_params(youtube)).to_not eq(original_params)
            expect(to_params(youtube)[:perf].count).to eq(
              original_params[:perf].count
            )
          end
          specify 'is valid' do
            expect(youtube).to be_valid
          end
        end
        context 'with 0a0c' do
          let(:new_youtube) { FactoryGirl.build(:youtube) }
          before { youtube.modify(to_params(
            new_youtube,
            timestamp: youtube.updated_at.to_s
          )) }
          include_context 'changes model counts' do
            let(:h) { { y: 0, p: 0, c: 0, a: 0 } }
            let(:count_of) { count }
          end
          specify 'changes associations' do
            expect(to_params(youtube)).to_not eq(original_params)
          end
          specify 'is not valid' do
            expect(youtube).to have(1).errors
            expect(youtube.errors[:performances]).to include('can\'t be blank')
          end
        end
      end
    end
  end
end
