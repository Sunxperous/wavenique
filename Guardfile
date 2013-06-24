guard 'spork', :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch('config/environments/test.rb')
  watch(%r{^config/initializers/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
end

group 'u-tests' do # Unit tests
  guard 'rspec',
  cli: '--drb',
  all_after_pass: false,
  spec_paths: ['spec/models', 'spec/lib', 'spec/complements'] do
    watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch(%r{^app/models/(.+)\.rb$}) { |m| "spec/models/#{m[1]}_spec.rb" }
    watch(%r{^app/complements/(.+)\.rb$}) { |m| "spec/complements/#{m[1]}_spec.rb" }

    # General purpose watch.
    watch(%r{^spec/.+_spec\.rb$})
    watch('spec/spec_helper.rb') { "spec" }
    watch(%r{^spec/support/(.+)\.rb$}) { "spec" }
  end
end

group 'f-tests' do # Functional tests
  guard 'rspec',
  cli: '--drb',
  all_on_start: false,
  all_after_pass: false,
  spec_paths: ['spec/helpers', 'spec/controllers', 'spec/views'] do
    watch(%r{^app/views/(.+)/.*\.(erb|haml)$}) { |m| "spec/features/#{m[1]}_spec.rb" }
    watch('app/controllers/application_controller.rb') { "spec/controllers" }
    watch(%r{^app/(.+)\.rb$})  { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^app/(.*)(\.erb|\.haml)$}) { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }

    # General purpose watch.
    watch(%r{^spec/.+_spec\.rb$})
    watch('spec/spec_helper.rb') { "spec" }
    watch(%r{^spec/support/(.+)\.rb$}) { "spec" }
  end
end

group 'i-tests' do # Integration tests
  guard 'rspec',
  cli: '--drb',
  all_on_start: false,
  all_after_pass: false,
  spec_paths: ['spec/features'] do
    #watch(%r{^app/views/(.+)/.*\.(erb|haml)$}) { |m| "spec/features/#{m[1]}_spec.rb" }
    
    # General purpose watch.
    watch(%r{^spec/features/.+_spec\.rb$})
    watch('spec/spec_helper.rb') { "spec" }
    watch(%r{^spec/support/(.+)\.rb$}) { "spec" }
  end
end

