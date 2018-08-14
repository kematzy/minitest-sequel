# require "minitest/sequel"
require 'minitest/spec'

# reopening to add schema validation functionality
module Minitest::Assertions

  # Conveniently test your Model definitions as follows:
  #
  #     let(:m) { Post.first }
  #
  #     it { assert_have_column(m, :title, type: :string, db_type: 'varchar(250)') }
  #     it { m.must_have_column(:title, type: :string, db_type: 'varchar(250)') }
  #
  #     # assert_have_column(<instance>, <column_name>, <options>, <custom_error_message>)
  #
  #     # <instance>.must_have_column(<column_name>, <options>, <custom_error_message>)
  #
  #
  # `assert_have_column()` first tests if the column name is defined in the Model and then checks
  # all passed options. The following options are valid and checked:
  #
  #  * :type
  #  * :db_type
  #  * :allow_null
  #  * :max_length
  #  * :default
  #  * :primary_key
  #  * :auto_increment
  #
  # In the event the specs differ from the actual database implementation an extensive error
  # message with the differing option(s) is provided to help speed up debugging the issue:
  #
  #     Expected Post model to have column: :title with: \
  #       { type: 'string', db_type: 'varchar(250)', allow_null: 'false' } \
  #       but found: { db_type: 'varchar(255)' }
  #
  #
  # **Please NOTE!**
  #
  # To test options with a value that is either `nil`, `true` or `false`, please use `:nil`,
  # `:false` or `:true` and provide numbers as 'strings' instead.
  #
  #
  def assert_have_column(obj, attribute, opts = {}, msg = nil)
    msg = msg.nil? ? "" : "#{msg}\n"
    msg << "Expected #{obj.class} model to have column: :#{attribute}"
    err_msg  = []
    conf_msg = []
    # check if column exists
    dcol = obj.db.schema(obj.class.table_name).detect { |c| c[0] == attribute }
    matching = !dcol.nil?

    # bail out if no matching column
    unless matching
      msg << " but no such column exists"
      assert(false, msg)
    end

    # bail out if options provided are invalid
    val_opts = [:type, :db_type, :allow_null, :max_length, :default, :primary_key, :auto_increment]
    invalid_opts = opts.keys.reject { |o| val_opts.include?(o) }
    unless invalid_opts.empty?
      msg << ", but the following invalid option(s) was found: { "
      invalid_opts.each { |o| msg << "#{o.inspect}; " }
      msg << " }. Valid options are: #{val_opts.inspect}"
      assert(false, msg)
    end

    # TODO: simplify this mess. quick fix didn't work, so look at it again when time permits.

    unless opts[:type].nil?
      expected = (dcol[1][:type].to_s == opts[:type].to_s)
      conf_msg << "type: '#{opts[:type]}'"
      unless expected
        err_msg << "type: '#{dcol[1][:type]}'"
      end
      matching &&= expected
    end

    unless opts[:db_type].nil?
      expected = (dcol[1][:db_type].to_s == opts[:db_type].to_s)
      conf_msg << "db_type: '#{opts[:db_type]}'"
      unless expected
        err_msg << "db_type: '#{dcol[1][:db_type]}'"
      end
      matching &&= expected
    end

    unless opts[:max_length].nil?
      expected = (dcol[1][:max_length] === opts[:max_length])
      conf_msg << "max_length: '#{opts[:max_length]}'"
      unless expected
        err_msg << "max_length: '#{dcol[1][:max_length]}'"
      end
      matching &&= expected
    end

    unless opts[:allow_null].nil?
      v = _convert_value(opts[:allow_null])
      expected = (dcol[1][:allow_null] === v)
      conf_msg << "allow_null: '#{opts[:allow_null]}'"
      unless expected
        err_msg << "allow_null: '#{dcol[1][:allow_null]}'"
      end
      matching &&= expected
    end

    unless opts[:default].nil?
      v = _convert_value(opts[:default])
      expected = (dcol[1][:default] === v)
      conf_msg << "default: '#{opts[:default]}'"
      unless expected
        err_msg << "default: '#{dcol[1][:default].inspect}'"
      end
      matching &&= expected
    end

    unless opts[:primary_key].nil?
      v = _convert_value(opts[:primary_key])
      expected = (dcol[1][:primary_key] === v)
      conf_msg << "primary_key: '#{opts[:primary_key]}'"
      unless expected
        err_msg << "primary_key: '#{dcol[1][:primary_key]}'"
      end
      matching &&= expected
    end

    unless opts[:auto_increment].nil?
      v = _convert_value(opts[:auto_increment])
      expected = (dcol[1][:auto_increment] === v)
      conf_msg << "auto_increment: '#{opts[:auto_increment]}'"
      unless expected
        err_msg << "auto_increment: '#{dcol[1][:auto_increment]}'"
      end
      matching &&= expected
    end

    msg = msg << " with: { #{conf_msg.join(', ')} } but found: { #{err_msg.join(', ')} }"
    assert(matching, msg)
  end

  #
  def refute_have_column(obj, attribute, msg = nil)
    msg = msg.nil? ? "" : "#{msg}\n"
    msg << "Expected #{obj.class} model to NOT have column: :#{attribute}"
    # check if column exists
    dcol = obj.db.schema(obj.class.table_name).detect { |col| col[0] == attribute }
    matching = dcol.nil?
    unless matching
      msg << " but such a column was found"
      assert(matching, msg)
    end
  end

end

# add support for Spec syntax
module Minitest::Expectations
  infect_an_assertion :assert_have_column, :must_have_column, :reverse
  infect_an_assertion :refute_have_column, :wont_have_column, :reverse
end
