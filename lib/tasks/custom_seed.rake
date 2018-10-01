namespace :db do
  namespace :reset do
    Dir[Rails.root.join('db', 'seeds', 'seed_*.rb')].each do |filename|
      task_name = File.basename(filename, '.rb')[5..-1]
      desc "Seed " + task_name + ", basé sur le fichier de nom similaire dans `db/seeds/seed_*.rb`"
      task task_name.to_sym => :environment do
        Rake::Task['db:drop'].invoke
        Rake::Task['db:setup'].invoke
        load(Rails.root.join('db','seeds_required.rb'))
        load(filename) if File.exist?(filename)
      end
      main_file = Rails.root.join('db','seeds_main.rb')
      task :main => :environment do
        Rake::Task['db:drop'].invoke
        Rake::Task['db:setup'].invoke
        load(main_file) if File.exist?(main_file)
      end
    end
  end
end
