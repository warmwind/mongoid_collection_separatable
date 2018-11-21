namespace :db do
  namespace :mongoid do
    namespace :collection do
      desc 'Separate records from one collection into another given a condition and new collection name'
      task :separate, [:origin_class, :condition_key, :condition_value] => :environment do |_t, args|

        origin_class = args[:origin_class].constantize
        target_collection = "#{origin_class.collection_name}_#{args[:condition_value]}"

        origin_class.collection.aggregate([
                                            {'$match': {args[:condition_key] => args[:condition_value]}},
                                            {'$out': target_collection}
                                          ])
      end
    end
  end
end
