# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :performance do
    ignore do
      a 1
      c 1
    end

    after(:build) do |performance, evaluator|
      # Artists evaluation.
      if evaluator.a.class == Fixnum
        evaluator.a.times do
          performance.artists << FactoryGirl.build(:artist)
        end
      else # Enumerable.
        evaluator.a.each do |v|
          performance.artists << v and next if v.class == Artist
          performance.artists << FactoryGirl.build(:artist, name: v) # Else.
        end
      end

      # Compositions evaluation.
      if evaluator.c.class == Fixnum
        evaluator.c.times do
          performance.compositions << FactoryGirl.build(:composition)
        end
      else # Enumerable.
        evaluator.c.each do |v|
          performance.compositions << v and next if v.class == Composition
          performance.compositions << FactoryGirl.build(:composition, title: v) # Else.
        end
      end

    end
  end
end
