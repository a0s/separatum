# (WIP) Separatum

Extract and transfer linked objects from one database into another.

## How you can use it

- Making seeds.rb as copy of production data for testing purposes
- Making separate database for AB-testing (performance or marketing purposes)
- Checking your data logical structure (it will raise on broken or unexisting links)
- Freeze state of a set of objects in time and export them as `Object.create` ruby-code

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
  use Separatum::Processors::UuidChanger  
  use Separatum::Exporters::ActiveRecordCode
end

```

Return generated ruby code for creating objects in a database

```ruby
start_object = User.find('any_uuid_you_want_to_start_from')
puts seeds_generator.(start_object)
```

## Building parts

### Separatum::Importers::ActiveRecord

Parameters:

  - max_depth (default: 3)
  - edge_classes
  - denied_classes 
  - denied_class_transitions
  - svg_file_name
  - dot_file_name

### Separatum::Importers::JsonFile

Parameters:

  - file_name
  
### Separatum::Processors::FieldChanger

Parameters:

  - 1st/2nd - class and field to change
  - 3rd/4th - class and method that will make transformation 
  - 3rd  - Proc or Block 
  
### Separatum::Exporters::ActiveRecord

### Separatum::Exporters::ActiveRecordCode

Parameters:

  - file_name
  - ignore_not_unique_classes
  
  
### Separatum::Exporters::JsonFile

Parameters:
  
  - file_name
  - pretty_print

## TODO

- Better README.md :)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/a0s/separatum.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
