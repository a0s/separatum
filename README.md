# (WIP) Separatum

Extract and transfer linked objects from one database into another.

## How you can use it

- Making seeds.rb as copy of production data for testing purposes
- Making separate database for AB-testing (performance or marketing purposes)
- Checking your data logical structure (it will raise on broken or unexisting links)

## UUID

It is better if you are using UUID primary key in every table you want to extract.
This will allow you to avoid problems (with primary keys and sequences) during importing objects into a new database.
Also `UuidChanger` can help you avoid collisions in case of importing same objects more than one time in the same database.

## Examples

```bash
gem install separatum
```

```ruby
require 'separatum'
```

### Extract and export

Build new exporter

```ruby
exporter = Separatum.build do
  use Separatum::Importers::ActiveRecord  # We are going to crawl ActiveRecord objects
  use Separatum::Converters::Object2Hash  # Most of the modules in Separatum is working with Hash-form of objects
  use Separatum::Processors::UuidChanger  # Hide production's UUIDs with no broken links 
  use Separatum::Exporters::JsonFile, file_name: 'separate.json' # Export object to json file                                      
end
```

Define start object and extract all linked records into `separate.json` file

```ruby
start_object = User.find('any_uuid_from_your_table')
exporter.(start_object)
```

### Import into new database

Build new importer

```ruby
importer = Separatum.build do
  use Separatum::Importers::JsonFile, file_name: 'separate.json' # We are going to import hashed objects from separate.json
  use Separatum::Converters::Hash2Object # Convert back to real objects (not persisted)
  use Separatum::Exporters::ActiveRecord # Save them (in one transaction for all objects in set)
end
```

Import records to a database from `separate.json` file

```ruby
importer.() # It returns set of persisted objects
```

### Extract and generate ruby code

```ruby
seeds_generator = Separatum.build do
  use Separatum::Importers::ActiveRecord
  use Separatum::Converters::Object2Hash
  use Separatum::Processors::UuidChanger
  use Separatum::Converters::Hash2Object
  use Separatum::Exporters::ActiveRecordCode
end

```

Return generated ruby code for creating objects in a database

```ruby
start_object = User.find('any_uuid_you_want_to_start_from')
puts seeds_generator.(start_object)
```

## TODO

- Data obfuscation (respecting to private data)
- Edge classes which limit fetching graph
- Timemachine for DateTime fields

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/a0s/separatum.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
