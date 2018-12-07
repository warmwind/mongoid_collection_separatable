# MongoidCollectionSeparatable

Support mongoid collections to be saved into and queried from separated collections with condition

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mongoid_collection_separatable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid_collection_separatable

## Usage
Add the following line into the model class that you want to split:
```ruby
  separated_by :form_id, parent_class: 'Form', on_condition: :entries_separated
```

When `on_condition` field in `parent_class` is set to true, current records referenced to `separated_by` field will be saved into separated collections. Default collections name will be `#{current_collection}_#{form_id_value}` 

Migration task to separate collections:
```bash
rake db:mongoid:collection:separate[origin_class,condition_key,condition_value]
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mongoid_collection_separatable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
