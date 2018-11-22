namespace :db do
  namespace :mongoid do
    namespace :collection do
      desc 'Separate records from one collection into another given a condition and new collection name. e.g. rake db:mongoid:collection:separate[Entry,form_id,5bf626b5c2a6f78321dafc50]'
      task :separate, [:origin_class, :condition_key, :condition_value] => :environment do |_t, args|
        Mongoid::CollectionSeparatable::Tasks::Separate.new(args).run
      end
    end
  end
end
