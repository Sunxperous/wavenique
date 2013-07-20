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
            wave: youtube,
            a: perf[:a],
            c: perf[:c],
            l: perf[:l]
          )
        end
      end
    end
  end
end
