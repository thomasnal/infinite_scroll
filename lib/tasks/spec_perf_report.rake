RSpec::Core::RakeTask.new('spec:perf_report') do |t|
  t.rspec_opts = '--tag perf_report -fd'
end
