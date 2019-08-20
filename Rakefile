task default: %w[test]

task :test do
  sh 'bundle exec rspec core clients persistence'
  sh 'yarn test'
end

task :server, [:port] do |_, args|
  if args[:port]
    sh "cd ./web && bundle exec rails s -p #{args[:port]}"
  else
    sh "cd ./web && bundle exec rails s"
  end
end

namespace :db do
  task :migrate do
    sh "cd ./web && bundle exec rake db:migrate"
  end

  namespace :generate do
    task :migration, [:migration_name] do |_, args|
      sh "cd ./web && bundle exec rails g migration #{args[:migration_name]}"

      puts "Moving migration from web/db/migrate to persistence/lib/migrations... You can find it there."

      require 'fileutils'
      web_migrations = File.join(__dir__, 'web/db/migrate/*')
      persistence_migrations = File.join([__dir__, 'persistence/lib/migrations'])

      FileUtils.mv(Dir.glob(web_migrations), persistence_migrations)
    end
  end
end
