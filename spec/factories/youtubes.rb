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
            c: perf[:c]
          )
        end
      end
    end
  end

  factory :performance do
    ignore do
      a 1
      c 1
    end
    after(:build) do |performance, evaluator|
      if evaluator.a.class == Fixnum
        evaluator.a.times do
          performance.artists << FactoryGirl.build(:artist)
        end
      else
        evaluator.a.each do |name|
          performance.artists << FactoryGirl.build(:artist, name: name)
        end
      end
      if evaluator.c.class == Fixnum
        evaluator.c.times do
          performance.compositions << FactoryGirl.build(:composition)
        end
      else
        evaluator.c.each do |title|
          performance.compositions << FactoryGirl.build(:composition, title: title)
        end
      end
    end
  end

  factory :artist do
    sequence(:name) { |n| "Name #{n}" }
  end
  factory :composition do
    sequence(:title) { |n| "Title #{n}" }
  end
end
