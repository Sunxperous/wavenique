FactoryGirl.define do
  factory :youtube do
    sequence(:video_id) { |n| "qwertyuiop#{n}"[-11..-1] }
    sequence(:channel_id) { |n| "Channel #{n}" }

    factory :youtube_with_perf do
      ignore do
        perf [{ a: 1, c: 1 }]
      end

      after(:build) do |youtube, evaluator|
        evaluator.perf.each do |perf|
          youtube.performances << FactoryGirl.build(
            :performance,
            youtube: youtube,
            artist_count: perf[:a],
            comp_count: perf[:c]
          )
        end
      end
    end
  end

  factory :performance do
    ignore do
      artist_count 1
      comp_count 1
    end

    after(:build) do |performance, evaluator|
      evaluator.artist_count.times {
        performance.artists << FactoryGirl.build(:artist)
      }
      evaluator.comp_count.times {
        performance.compositions << FactoryGirl.build(:composition)
      }
    end
  end

  factory :artist do
    sequence(:name) { |n| "Name #{n}" }
  end

  factory :composition do
    sequence(:title) { |n| "Title #{n}" }
  end
end
