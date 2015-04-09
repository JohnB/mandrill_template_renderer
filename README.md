# MandrillTemplateRenderer

See the [Mandrill site](http://help.mandrill.com/entries/21694868-Getting-Started-with-Templates) for details on
their templates, with merge tags 
[described here](http://help.mandrill.com/entries/21678522-How-do-I-use-merge-tags-to-add-dynamic-content-).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mandrill_template_renderer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mandrill_template_renderer

## Usage
```ruby
  template = "text *|field|* *|IF:someOtherField|* conditionalText *|END:IF|* more text"
  hash = {field: 'value', someOtherField: 'anyValue'}
  result = MandrillTemplateRenderer.new(template).to_s(hash)
  => "text value  conditionalText  more text"

  hash = {field: 'value'}
  result = MandrillTemplateRenderer.new(template).to_s(hash)
  => "text value  more text"
```

## Testing
```
  ruby test/mandrill_template_renderer_test.rb 
```
## Contributing

1. Fork it [here](https://github.com/JohnB/mandrill_template_renderer#fork-destination-box)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

# License

This project rocks and uses MIT-LICENSE.
