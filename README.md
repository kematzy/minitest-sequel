# Minitest-Sequel

[Minitest](https://github.com/seattlerb/minitest) assertions to speed-up development and testing of
[Sequel](http://sequel.jeremyevans.net/) database setups.

The general hope is that this gem will contain a variety of useful assertions in all areas of testing Sequel database
code within your apps, gems, etc.

Please help out with missing features / functionality.

-----

## Model Definitions


### `assert_have_column ()` or `.must_have_column()`

Conveniently test your Model definitions as follows:

```ruby
let(:m) { Post.first }

it { assert_have_column(m, :title, type: :string, db_type: 'varchar(250)', allow_null: :false) }

it { m.must_have_column(:title, type: :string, allow_null: :false) }

it { m.must_have_column(:title, { type: :string, allow_null: :false }, "Custom messsage goes here") }

# definition of args
# assert_have_column(
#   <instance>,
#   <column_name>,
#   <options>,
#   <custom_error_message>
# )
```

The `assert_have_column()` method first tests if the column name is defined in the Model and then checks all passed options.


The following options are valid and checked:

 * `:type`
 * `:db_type`
 * `:allow_null`
 * `:max_length`
 * `:default`
 * `:primary_key`
 * `:auto_increment`


In the event the specs differ from the actual database implementation an extensive error message with the
differing option(s) is provided to help speed up debugging the issue:

```
Expected Post model to have column: :title with: \
  { type: 'string', db_type: 'varchar(250)', allow_null: 'false' } \
  but found: { db_type: 'varchar(255)' }
```

**Please NOTE!**

To test options with a value that is either `nil`, `true` or `false`, please use `:nil`, `:false` or `:true` and provide
numbers as 'strings' instead, ie: `'1'` instead of `1`.


<br>
<br>

----

<br>


## Associations

Conveniently test model associations quickly and easily with these Minitest assertions:

* `assert_association_one_to_one`

* `assert_association_one_to_many`

* `assert_association_many_to_one`

* `assert_association_many_to_many`

* `assert_association`

<br>
<br>


### `:one_to_one` association


A model defined with an association like this:


```ruby
class Post < Sequel::Model
  one_to_one :first_comment, class: :Comment, order: :id
end
```

Can be easily and quickly tested with `assert_association_one_to_one()` like this:

```ruby
let(:m) { Post.first }

it { assert_association_one_to_one(m, :first_comment)
 # or
it { m.must_have_one_to_one_association(:first_comment) }


 # definition of args
assert_association_one_to_one(
  <model_instance>,
  <association_name>,   # ie: :first_comment
  <options>,
  <custom_error_message>
)
```

In the event of errors an extensive error message is provided:

```
 # example error message

Expected Author to have a :one_to_one association :key_posts but no association \
 ':key_posts' was found - available associations are: [ \
  {:attribute=>:posts, :type=>:one_to_many, :class=>:Post, :keys=>[:author_id]}, \
  {:attribute=>:key_post, :type=>:one_to_one, :class=>:Post, :keys=>[:author_id]} \
 ]
```

<br>
<br>

### `:one_to_many` association

A model defined with an association like this:

```ruby
class Post < Sequel::Model
  one_to_many :comments
end
```

Can be easily and quickly tested with `assert_association_one_to_many()` like this:

```ruby
let(:p) { Post.first }

it { assert_association_one_to_many(p, :comments) }
 # or
it { m.must_have_one_to_many_association(:comments) }
```    

As above the assertion provides an extensive error message if something is wrong.

<br>
<br>

### `:many_to_one`  association

A model defined with an association like this:

```ruby
class Post < Sequel::Model
  many_to_one :author
end
```

Can be easily and quickly tested with `assert_association_many_to_one()` like this:

```ruby
let(:p) { Post.first }

it { assert_association_many_to_one(p, :author) }
 # or
it { m.must_have_many_to_one_association(:author) }
```    


As above the assertion provides an extensive error message if something is wrong.

<br>
<br>

### `:many_to_many`  association

A model defined with an association like this:

```ruby
class Post < Sequel::Model
  many_to_many :categories
end
```

Can be easily and quickly tested with `assert_association_many_to_many()` like this:

```ruby
let(:p) { Post.first }

it { assert_association_many_to_many(p, :categories) }
 # or
it { m.must_have_many_to_many_association(:categories) }
```    

If something is wrong an extensive error message is provided:

```
Expected Category to have a :many_to_many association :posts with given options: \
  {:class_name=>'Posts'} but should be {:class_name=>'Post' }
```

or

```
Expected Category to have a :many_to_many association :post but no association \
 ':post' was found - available associations are: [ \
  { :attribute=>:posts, :type=>:many_to_many, :class=>:Post, :join_table=>:categories_posts, \
    :left_keys=>[:category_id], :right_keys=>[:post_id]
  }
 ]
```

<br>
<br>

### `assert_association() assertion`
spec: `.must_have_association()`

if the above assertion methods are insufficient, you can use the base `assert_association` method instead.

```ruby
it "should have a :one_through_one association" do
  assert_association(Post, :one_through_one, :author)
   # or
  Post.must_have_association(:one_through_one, :author)
end

 # definition of args
assert_association(
  <model_class>,
  <association_type>,
  <association_name>,
  <options>,
  <custom_error_message>
)
```

<br>
<br>

----

<br>

## Validations

If you are using the recommended `:validation_class_methods` plugin in your app, the following instance validation methods are supported:

 * `assert_validates_presence()`

 * `assert_validates_exact_length()`

 * `assert_validates_length_range()`

 * `assert_validates_max_length()`

 * `assert_validates_min_length()`

 * `assert_validates_format()`

 * `assert_validates_inclusion()`

 * `assert_validates_integer()`

 * `assert_validates_numericality()`

 * `assert_validates_uniqueness()`

 * `assert_validates_acceptance()`

 * `assert_validates_confirmation()`

With all valid options checked

---

#### `assert_validates_presence(obj, attribute, opts = {}, msg = nil)`
alias: `:assert_validates_presence_of`

Test for validating presence of a model attribute

```ruby
it { assert_validates_presence(model, :title) }
it { model.must_validate_presence_of(:title, { message: '...' }) }
```
<br>


#### `assert_validates_length(obj, attribute, opts = {}, msg = nil)`
alias `:assert_validates_length_of`

Test for validating the length of a model's attribute.

Available options:

* :message - The message to use (no default, overrides :nil_message, :too_long, :too_short, and :wrong_length options if present)

* :nil_message - The message to use use if :maximum option is used and the value is nil (default: 'is not present')

* :too_long - The message to use use if it the value is too long (default: 'is too long')

* :too_short - The message to use use if it the value is too short (default: 'is too short')

* :wrong_length - The message to use use if it the value is not valid (default: 'is the wrong length')

Size related options:

* :is - The exact size required for the value to be valid (no default)

* :minimum - The minimum size allowed for the value (no default)

* :maximum - The maximum size allowed for the value (no default)

* :within - The array/range that must include the size of the value for it to be valid (no default)

```ruby
it { assert_validates_length(model, :title, { maximum: 12 }) }
it { model.must_validate_length_of(:title, { within: 4..12 }) }
```
<br>


#### `assert_validates_exact_length(obj, attribute, exact_length, opts = {}, msg = nil)`
alias: `:assert_validates_exact_length_of`

Test for validating the exact length of a model's attribute.

```ruby
it { assert_validates_exact_length(model, :title, 12, { message: '...' }) }
it { model.must_validate_exact_length_of(:title, 12, { message: '...' }) }
```
<br>


#### `assert_validates_length_range(obj, attribute, range, opts = {}, msg = nil)`
alias: `:assert_validates_length_range_of`

Test for validating the exact length of a model's attribute.

```ruby
it { assert_validates_length_range(model, :title, 4..12, { message: '...' }) }
it { model.must_validate_length_range_of(:title, 4..12, { message: '...' }) }
```

<br>


#### `assert_validates_max_length(obj, attribute, max_length, opts = {}, msg = nil)`
alias: `:assert_validates_max_length_of`

Test for validating the maximum length of a model's attribute.

```ruby
it { assert_validates_max_length(model, :title, 12, { message: '...' }) }
it { model.must_validate_max_length_of(:title, 12, { message: '...' }) }
```

<br>


#### `assert_validates_min_length(obj, attribute, min_length, opts = {}, msg = nil)`
alias: `:assert_validates_min_length_of`

Test for validating the minimum length of a model's attribute.

```ruby
it { assert_validates_min_length(model, :title, 12, { message: '...' }) }
it { model.must_validate_min_length_of(:title, 12, { message: '...' }) }
```

<br>


#### `assert_validates_format(obj, attribute, opts = {}, msg = nil)`
alias: `:assert_validates_format_of`

Test for validating the format of a model's attribute with a regexp.

```ruby
it { assert_validates_format(model, :title, 12, { with: /[a-z+]/ }) }
it { model.must_validate_format_of(:title, 12, { with: /[a-z]+/ }) }
```

<br>


#### `assert_validates_inclusion(obj, attribute, opts = {}, msg = nil)`
alias: `:assert_validates_inclusion_of`

Test for validating that a model's attribute is within a specified range or set of values.

```ruby
it { assert_validates_inclusion(model, :status, { in: [:a, :b, :c] }) }
it { model.must_validate_inclusion_of(:status, { in: [:a, :b, :c] }) }
```

<br>


#### `assert_validates_integer(obj, attribute, opts = {}, msg = nil)`
alias: none

Test for validating that a a model's attribute is an integer.

```ruby
it { assert_validates_integer(model, :author_id, { message: '...' }) }
it { model.must_validate_integer_of(:author_id, { message: '...' }) }
```

<br>


#### `assert_validates_numericality(obj, attribute, opts = {}, msg = nil)`
alias: `:assert_validates_numericality_of`

Test for validating that a model's attribute is numeric (number).

```ruby
it { assert_validates_numericality(model, :author_id, { message: '...' }) }
it { model.must_validate_numericality_of(:author_id, { message: '...' }) }
```

<br>


#### `assert_validates_uniqueness(obj, attribute, opts = {}, msg = nil)`
alias: `:assert_validates_uniqueness_of`

Test for validating that a model's attribute is unique.

```ruby
it { assert_validates_uniqueness(model, :urlslug, { message: '...' }) }
it { model.must_validate_uniqueness_of(:urlslug, { message: '...' }) }
```

<br>


#### `assert_validates_acceptance(obj, attribute, opts = {}, msg = nil)`
alias: `assert_validates_acceptance_of`

Test for validating the acceptance of a model's attribute.

```ruby
it { assert_validates_acceptance(Order.new, :toc, { message: '...' }) }
it { model.must_validate_acceptance_of(:toc, { message: '...' }) }
```

<br>


#### `assert_validates_confirmation(obj, attribute, opts = {}, msg = nil)`
alias: `:assert_validates_confirmation_of`

Test for validating the confirmation of a model's attribute.

```ruby
it { assert_validates_confirmation(User.new, :password, { message: '...' }) }
it { User.new.must_validate_confirmation_of(:password, { message: '...' }) }
```

<br>


Each validation assertion have a responding negative test, ie: `refute_validate_presence()`


### Usage

A model defined with validations like this:

```ruby
class Post < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence(:title)
    validates_format(/\w+/, :title)
  end
end
```

Can be quickly tested like this:

```ruby
 # <snip...>

let(:m) { Post.first }

it "should validate presence of :title column" do
  assert_validates_presence(m, :title)
end

it "should validate format of :title column with regexp" do
  assert_validates_format(m, :title, /\w+/)
end
```

<br>
<br>

----

<br>

## Plugins

This gem also contains a collection of "helpers" that aid working with Sequel models:


#### `assert_timestamped_model(model, opts = {}, msg = nil)`

Quickly test if a model class is timestamped with .plugin(:timestamps) with [Sequel-Timestamps](http://sequel.jeremyevans.net/rdoc-plugins/classes/Sequel/Plugins/Timestamps.html)


```ruby
 # Declared locally in the Model
 class Comment < Sequel::Model
   plugin(:timestamps)
 end
 proc { assert_timestamped_model(Comment) }.wont_have_error

 # on a non-timestamped model
 class Post < Sequel::Model; end
 proc { assert_timestamped_model(Post) }.must_have_error(/Not a \.plugin\(:timestamps\) model, available plugins are/)
```

**NOTE!**

You can also pass attributes to the created model in the tests via the `opts` hash like this:

```ruby
proc { assert_timestamped_model(Comment, {body: "I think...", email: "e@email.com"}) }.wont_have_error
```
   
Timestamps can be declared globally for all models via `Sequel::Model.plugin(:timestamps)` before the models are migrated.


#### `assert_timestamped_model_instance(model, opts = {}, msg = nil)`

Test if a model instance is timestamped with the .plugin(:timestamps) via [Sequel-Timestamps](http://sequel.jeremyevans.net/rdoc-plugins/classes/Sequel/Plugins/Timestamps.html)

```ruby
let(:m) { Post.create(title: "Dummy") }
proc { assert_timestamped_model_instance(m) }.wont_have_error
```


You can also test if an updated record is correctly timestamped

```ruby
m.title = "Updated"
m.save
proc { assert_timestamped_model_instance(m, updated_record: true) }.wont_have_error
```

Or alternatively test if an updated record is wrongly timestamped

```ruby
let(:m) { Post.create(title: "Dummy", updated_at: Time.now) }
proc { assert_timestamped_model_instance(m, updated_record: false) }.must_have_error(/expected #.updated_at to be NIL on new record/)
```


<br>

#### `assert_paranoid_model(model, opts = {}, msg = nil)`

Test if a model class is paranoid with .plugin(:paranoid) via [Sequel-Paranoid](https://github.com/sdepold/sequel-paranoid)

```ruby
# Declared locally in the Model
class Comment < Sequel::Model
 plugin(:paranoid)
end
proc { assert_paranoid_model(Comment) }.wont_have_error

# on a non-paranoid model
class Post < Sequel::Model; end
proc { assert_paranoid_model(Post) }.must_have_error(/Not a plugin\(:paranoid\) model, available plugins are/)
```

**NOTE!**

You can also pass attributes to the created model in the tests via the `opts` hash like this:

```ruby
proc { assert_timestamped_model(Comment, {body: "I think...", email: "e@email.com"}) }.wont_have_error
```


<br>

#### `refute_timestamped_model(model, msg = nil)`

Test to ensure a model is NOT declared with .plugin(:timestamps) using [Sequel-Timestamps](http://sequel.jeremyevans.net/rdoc-plugins/classes/Sequel/Plugins/Timestamps.html)


Test if a model class is paranoid with .plugin(:paranoid) via [Sequel-Paranoid](https://github.com/sdepold/sequel-paranoid)

```ruby
class Comment < Sequel::Model
 plugin(:timestamps)
end
proc { refute_timestamped_model(Comment) }.must_have_error(/expected Comment to NOT be a :timestamped model, but it was/)

# on a non-timestamped model
class Post < Sequel::Model; end
it { refute_timestamped_model(Post) }
```

<br>

#### `refute_paranoid_model(model, msg = nil)`

Test to ensure a model is NOT declared with .plugin(:paranoid) using [Sequel-Paranoid](https://github.com/sdepold/sequel-paranoid)

```ruby
class Comment < Sequel::Model
 plugin(:paranoid)
end
proc { refute_paranoid_model(Comment) }.must_have_error(/expected Comment to NOT be a :paranoid model, but it was/)

# on a non-paranoid model
class Post < Sequel::Model; end
it { refute_paranoid_model(Post) }
```


<br>

<br>
<br>

----

<br>

## Miscellaneous Helpers

This gem also contains a collection of "helpers" that aid working with Sequel models:

<br>

#### `ensure_working_CRUD(obj, attribute)`

Enables quick tests to ensure that the basic CRUD functionality is working correctly for a Model

```ruby
ensure_working_CRUD(User, :name)
```

**NOTE!**
* the passed `_model` argument must be the actual Model class and NOT a string or symbol
* the passed attribute `_attr` must be a String attribute or the tests will fail

**DEPENDENCIES**

This test depends upon being able to create a new model instance for each test via using
[Sequel Factory's](https://github.com/mjackson/sequel-factory) `#make()` method


<br>
<br>

----

<br>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'minitest-sequel'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install minitest-sequel
```

## Usage

In your project's `spec/spec_helper.rb` or `test/test_helper.rb` file ensure the following code is present:


```ruby   
gem 'minitest'

require 'minitest/autorun'
require 'minitest/sequel'  # NB!! can be loaded after minitest/autorun

require 'sqlite3' # using sqlite for tests

 # The preferred default validations plugin, which uses class-level methods.
Sequel::Model.plugin(:validation_class_methods)

 # connect to database
DB = Sequel.sqlite # :memory

 ## add migrations and seeds below

DB.create_table(:posts) do
  primary_key :id
  # <snip...>
end

 # <snip...>
```

Then in your tests you should be good to go when using the sequel assertions.



## Development

After checking out the repo, run `bundle install` to install all dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`,
which will create a git tag for the version, push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kematzy/minitest-sequel/issues.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere
to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
