# frozen_string_literal: false

# reopening to add validations functionality
module Minitest
  # add support for Assert syntax
  module Assertions
    # Asserts that a given model has a specific column with optional attribute checks
    #
    # @param obj [Object] The model instance to check
    # @param attribute [Symbol] The name of the column to check
    # @param opts [Hash] Optional attributes to verify for the column
    # @param msg [String, nil] Optional custom error message
    #
    # @example Basic usage
    #   let(:m) { Post.first }
    #   assert_have_column(m, :title, type: :string, db_type: 'varchar(250)')
    #
    # @example Using with Spec syntax
    #   m.must_have_column(:title, type: :string, db_type: 'varchar(250)')
    #
    # The method checks if the column exists in the model and then verifies
    # any provided options. Valid options include:
    #
    #  * :type - The Ruby type of the column
    #  * :db_type - The database-specific type of the column
    #  * :allow_null - Whether the column allows NULL values
    #  * :max_length - The maximum length for string-type columns
    #  * :default - The default value for the column
    #  * :primary_key - Whether the column is a primary key
    #  * :auto_increment - Whether the column auto-increments
    #
    # If the actual column attributes differ from the specified options,
    # a detailed error message is provided:
    #
    #     Expected Post model to have column: :title with: \
    #       { type: 'string', db_type: 'varchar(250)', allow_null: 'false' } \
    #       but found: { db_type: 'varchar(255)' }
    #
    # @note When testing for `nil`, `true`, or `false` values, use `:nil`,
    #   `:true`, or `:false` symbols respectively. For numeric values,
    #   provide them as strings.
    #
    def assert_have_column(obj, attribute, opts = {}, msg = nil)
      # Prepare the error message
      msg = build_message_column(obj, attribute, msg)

      # prepare output messages
      msg_conf = []
      msg_err = []

      # extract the db table information for the column
      dbcol = extract_column_info(obj, attribute)

      # set matching status
      matching = !dbcol.nil?

      # bail if there is no matching column
      bail_unless_column_exists(dbcol, msg) unless matching
      # bail if passed options are invalid
      bail_unless_valid_options(opts, msg)

      # loop through the options passed and check them and report the result
      opts.each do |key, value|
        expected = compare_column_attribute(dbcol, key, value)
        update_messages(msg_conf, msg_err, key, value, dbcol, expected)
        matching &&= expected
      end

      msg << " with: { #{msg_conf.join(', ')} } but found: { #{msg_err.join(', ')} }"
      assert(matching, msg)
    end

    # Asserts that a given model does not have a specific column
    #
    # @param obj [Object] The model instance to check
    # @param attribute [Symbol] The name of the column to check for absence
    # @param msg [String, nil] Optional custom error message
    #
    # @example
    #   refute_have_column(user, :admin_flag)
    #
    def refute_have_column(obj, attribute, msg = nil)
      # Prepare the error message
      msg = build_message_column(obj, attribute, msg, refute: true)

      # extract the column information from the database schema
      dbcol = extract_column_info(obj, attribute)

      # If the column is not found (dcol is nil), the test passes
      matching = dbcol.nil?

      # Return early if the test passes (column doesn't exist)
      return if matching

      # If we reach here, it means the column was found when it shouldn't be
      msg << ' but such a column was found'

      # Assert that matching is true (which it isn't at this point)
      # This will raise an assertion error with the prepared message
      assert(matching, msg)
    end

    private

    # Builds an error message for column assertions
    #
    # @param obj [Object] The model instance to check
    # @param attribute [Symbol] The name of the column to check for absence
    # @param msg [String, nil] Custom error message
    # @param refute [Boolean] Whether this is for a refutation (default: false)
    #
    # @return [String] The formatted error message
    #
    def build_message_column(obj, attribute, msg, refute: false)
      msg = msg.nil? ? '' : "#{msg}\n"
      msg << "Expected #{obj.class} model to #{refute ? 'NOT ' : ''}have column: :#{attribute}"
    end

    # Extracts the column information for a given attribute in the database schema
    #
    # @param obj [Object] The model instance to check
    # @param attribute [Symbol] The name of the column to find
    #
    # @return [Array, nil] The column information array if found, nil otherwise
    #
    # @example
    #   extract_column_info(user, :email)
    #   # => [:email, {:type=>:string, :db_type=>"varchar(255)", :allow_null=>true, ...}]
    #
    def extract_column_info(obj, attribute)
      obj.db.schema(obj.class.table_name).detect { |c| c[0] == attribute }
    end

    # Bail if the specified column does not exist in the database schema
    #
    # @param dcol [Array, nil] The database column information, or nil if the column doesn't exist
    # @param msg [String] The error message to be displayed if the column doesn't exist
    #
    # @raise [Minitest::Assertion] If the column doesn't exist in the database schema
    #
    # @example
    #   bail_unless_column_exists(column_info, error_message)
    #
    def bail_unless_column_exists(dbcol, msg)
      unless dbcol
        msg << ' but no such column exists'
        assert(false, msg)
      end
    end

    # Bail if the options passed to #assert_have_column are invalid
    #
    # @param opts [Hash] The options to validate
    #
    # @raise [Minitest::Assertion] If any invalid options are found
    #
    # @example
    #   bail_unless_valid_options(type: :string, db_type: 'varchar(255)')
    #
    def bail_unless_valid_options(opts, msg)
      valid_opts = %i[type db_type allow_null default primary_key auto_increment max_length]
      invalid_opts = opts.keys.reject { |o| valid_opts.include?(o) }

      unless invalid_opts.empty?
        msg << ', but the following invalid option(s) was found: { '
        msg << invalid_opts.map(&:inspect).join(', ')
        msg << " }. Valid options are: #{valid_opts.inspect}"

        assert(false, msg)
      end
    end

    # Compares the actual column attribute with the expected value
    #
    # @param dbcol [Array] The database column information
    # @param key [Symbol] The attribute key to compare
    # @param value [Object] The expected value for the attribute
    #
    # @return [Boolean] True if the attribute matches the expected value, false otherwise
    #
    def compare_column_attribute(dbcol, key, value)
      case key
      when :type, :db_type
        dbcol[1][key].to_s == value.to_s
      when :allow_null, :default, :primary_key, :auto_increment
        dbcol[1][key] === _convert_value(value)
      when :max_length
        dbcol[1][key] === value
      end
    end

    # Updates the confirmation and error messages based on column attribute comparison
    #
    # @param msg_conf [Array] Array to store confirmation messages
    # @param msg_err [Array] Array to store error messages
    # @param key [Symbol] The attribute key being compared
    # @param value [Object] The expected value for the attribute
    # @param dbcol [Array] The database column information
    # @param expected [Boolean] Whether the attribute matches the expected value
    #
    # @example
    #   update_messages(msg_conf, msg_err, :type, 'string', column_info, true)
    #
    def update_messages(msg_conf, msg_err, key, value, dbcol, expected)
      msg_conf << "#{key}: '#{value}'"
      val = key == 'default' ? dbcol[1][key].inspect : dbcol[1][key]
      msg_err << "#{key}: '#{val}'" unless expected
    end
  end
  # /module Assertions

  # add support for Spec syntax
  module Expectations
    infect_an_assertion :assert_have_column, :must_have_column, :reverse
    infect_an_assertion :refute_have_column, :wont_have_column, :reverse
  end
end
