task default: %w[test]

task :test do
  sh 'bundle exec rspec core clients persistence'
end

task :server, [:port] do |_, args|
  if args[:port]
    sh "cd ./web && bundle exec rails s -p #{args[:port]}"
  else
    sh "cd ./web && bundle exec rails s"
  end
end
