# Minitest-Sequel

[Minitest](https://github.com/seattlerb/minitest) assertions to speed-up development and testing of 
[Sequel](http://sequel.jeremyevans.net/) database setups.

The general hope is that this gem will contain a variety of useful assertions in all areas of testing Sequel database 
code within your apps, gems, etc.

Please help out with missing features / functionality.

-----

## Model Definitions


### `assert_have_column ()`

Conveniently test your Model definitions as follows:

    let(:m) { Post.first }
    
    it { assert_have_column(m, :title, type: :string, db_type: 'varchar(250)', allow_null: :false ) }
    
    # definition of args
    assert_have_column(<instance>, <column_name>, <options>, <custom_error_message>)


The `assert_have_column()` method first tests if the column name is defined in the Model and then checks all passed options. 


The following options are valid and checked:

 * :type
 * :db_type
 * :allow_null
 * :max_length
 * :default
 * :primary_key
 * :auto_increment


In the event the specs differ from the actual database implementation an extensive error message with the 
differing option(s) is provided to help speed up debugging the issue:

    Expected Post model to have column: :title with: \
      { type: 'string', db_type: 'varchar(250)', allow_null: 'false' } \
      but found: { db_type: 'varchar(255)' }


**Please NOTE!**

To test options with a value that is either `nil`, `true` or `false`, please use `:nil`, `:false` or `:true` and provide 
numbers as 'strings' instead, ie: '1' instead of 1.


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

    class Post < Sequel::Model
      one_to_one :first_comment, :class=>:Comment, :order=>:id
    end

Can be easily and quickly tested with `assert_association_one_to_one()` like this:

    let(:m) { Post.first }
    
    it { assert_association_one_to_one(m, :first_comment) }    
    
    
    # definition of args
    assert_association_one_to_one( 
      <model_instance>, 
      <association_name>,   # ie: :first_comment
      <options>,
      <custom_error_message>
    )


In the event of errors an extensive error message is provided:

    # example error message
    
    Expected Author to have a :one_to_one association :key_posts but no association ':key_posts' was found - 
      available associations are: [ \
        {:attribute=>:posts, :type=>:one_to_many, :class=>:Post, :keys=>[:author_id]}, \
        {:attribute=>:key_post, :type=>:one_to_one, :class=>:Post, :keys=>[:author_id]} \
      ]

<br>
<br>

### `:one_to_many` association

A model defined with an association like this:

    class Post < Sequel::Model
      one_to_many :comments
    end

Can be easily and quickly tested with `assert_association_one_to_many()` like this:

    let(:p) { Post.first }
    
    it { assert_association_one_to_many(p, :comments) }
    

As above the assertion provides an extensive error message if something is wrong.

<br>
<br>

### `:many_to_one`  association

A model defined with an association like this:

    class Post < Sequel::Model
      many_to_one :author
    end

Can be easily and quickly tested with `assert_association_many_to_one()` like this:

    let(:p) { Post.first }
    
    it { assert_association_many_to_one(p, :author) }
    


As above the assertion provides an extensive error message if something is wrong.

<br>
<br>

### `:many_to_many`  association

A model defined with an association like this:

    class Post < Sequel::Model
      many_to_many :categories
    end

Can be easily and quickly tested with `assert_association_many_to_many()` like this:

    let(:p) { Post.first }
    
    it { assert_association_many_to_many(p, :categories) }
    

If something is wrong an extensive error message is provided:

    Expected Category to have a :many_to_many association :posts with given options: \
      {:class_name=>'Posts'} but should be {:class_name=>'Post' }
  
or
  
    Expected Category to have a :many_to_many association :post but no association ':post' was found - \
      available associations are: [ \
        { :attribute=>:posts, :type=>:many_to_many, :class=>:Post, :join_table=>:categories_posts, \
          :left_keys=>[:category_id], :right_keys=>[:post_id]
        } 
      ]


<br>
<br>

### `assert_association() assertion`

if the above assertion methods are insufficient, you can use the base `assert_association` method instead.

    it "should have a :one_through_one association" do
      assert_association(Post, :one_through_one, :author)
    end
    
    
    # 
    assert_association(
      <model_class>, <association_type>, <association_name>, <options>, <custom_error_message>
    )


<br>
<br>

----

<br>

## Validations

**NOTE! NOT YET IMPLEMENTED! WORK IN PROGRESS**


If you are using the recommended `:validation_helpers` plugin in your app, the following instance validation methods 
are supported:

 * `validates_presence`
 
 * `validates_exact_length`
 
 * `validates_length_range`
 
 * `validates_max_length`
 
 * `validates_min_length`
 
 * `validates_format`
 
 * `validates_includes`
 
 * `validates_integer`
 
 * `validates_not_string`
 
 * `validates_numeric`
 
 * `validates_unique`


The following valid options will be checked:

 * `:allow_blank`
 * `:allow_missing`
 * `:allow_nil`
 * `:message`


### Usage

A model defined with validations like this:

    class Post < Sequel::Model
      plugin :validation_helpers
      
      def validate
        super
        validates_presence(:title)
        validates_format(/\w+/, :title)
      end
    end

Can be quickly tested like this:

    <snip...>
    
    let(:m) { Post.first }
    
    it "shoud validate presence of :title column" do
      assert_validates_presence(m, :title)
    end
    
    it "shoud validate format of :title column with regexp" do
      assert_validates_format(m, :title, /\w+/)
    end



## Installation

Add this line to your application's Gemfile:

    gem 'minitest-sequel'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install minitest-sequel


## Usage

In your project's `spec/spec_helper.rb` or `test/test_helper.rb` file ensure the following code is present:

    
    gem 'minitest'
    
    require 'minitest/sequel'   # NB!! must be loaded before minitest/autorun
    require 'minitest/autorun'
     
    require 'sqlite3' # using sqlite for tests
    
    # The preferred default validations plugin, which uses instance-level methods.
    Sequel::Model.plugin(:validation_helpers)
    
    # connect to database
    DB = Sequel.sqlite # :memory
    
    ## add migrations and seeds below
    
    DB.create_table(:posts) do
      primary_key :id
      <snip...>
    end
    
    <snip...>


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

