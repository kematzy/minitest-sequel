require "minitest/sequel/version"
require 'sequel'

module Minitest
  module Sequel
    
    
    # Conveniently test your Model definitions as follows:
    #
    #       let(:m) { Post.first }
    #
    #       it { assert_have_column(m, :title, type: :string, db_type: 'varchar(250)', allow_null: :false ) }
    #
    #       # assert_have_column(<instance>, <column_name>, <options>, <custom_error_message>)
    #
    #
    # `assert_have_column()` first tests if the column name is defined in the Model and then checks all passed options.
    # The following options are valid and checked:
    #
    #  * :type
    #  * :db_type
    #  * :allow_null
    #  * :max_length
    #  * :default
    #  * :primary_key
    #  * :auto_increment
    #
    # In the event the specs differ from the actual database implementation an extensive error message 
    # with the differing option(s) is provided to help speed up debugging the issue:
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
    def assert_have_column(obj, attribute, opts={}, msg=nil)
      msg = msg.nil? ? '' : "#{msg}\n"
      msg << "Expected #{obj.class} model to have column: :#{attribute.to_s}"
      err_msg = []; conf_msg = []
      # check if column exists
      col = obj.db.schema(obj.class.table_name).detect{|col| col[0]==attribute}
      matching = !col.nil?
      
      # bail out if no matching column
      unless matching
        msg << " but no such column exists" 
        assert matching, msg
      end
      
      # bail out if options provided are invalid
      valid_opts    = [:type, :db_type, :allow_null, :max_length, :default, :primary_key, :auto_increment]
      invalid_opts  = opts.keys.reject { |o| valid_opts.include?(o) }
      unless invalid_opts.empty?
        msg << " : ERROR: invalid option(s) provided: { "
        invalid_opts.each{|o| msg << "#{o.inspect}; " }
        msg << " } valid options are: #{valid_opts.inspect}"
        assert false, msg
      end
      
      # carry on...  
      
      # check type
      unless opts[:type].nil?
        expected = (col[1][:type].to_s == opts[:type].to_s)
         conf_msg << "type: '#{opts[:type]}'" 
        unless expected
          err_msg << "type: '#{col[1][:type]}'" 
        end
        matching &&= expected
      end
      
      # check db_type
      unless opts[:db_type].nil?
        expected = (col[1][:db_type].to_s == opts[:db_type].to_s)
        conf_msg << "db_type: '#{opts[:db_type]}'" 
        unless expected
          err_msg << "db_type: '#{col[1][:db_type]}'" 
        end
        matching &&= expected
      end
      
      # check :allow_null
      unless opts[:allow_null].nil?
        _v = _convert_value(opts[:allow_null])
        expected = (opts[:allow_null] === _v)
        conf_msg << "allow_null: '#{opts[:allow_null]}'" 
        unless expected
          err_msg << "allow_null: '#{col[1][:allow_null]}'"
        end
        matching &&= expected
      end
      
      # check :max_length
      unless opts[:max_length].nil?
        expected = (col[1][:max_length] === opts[:max_length])
        conf_msg << "max_length: '#{opts[:max_length]}'" 
        unless expected
          err_msg << "max_length: '#{col[1][:max_length]}'" 
        end
        matching &&= expected
      end
      
      # check :default
      unless opts[:default].nil?
        _v = _convert_value(opts[:default])
        expected = (col[1][:default] === _v )
        conf_msg << "default: '#{opts[:default]}'" 
        unless expected
          err_msg << "default: '#{col[1][:default].inspect}'" 
        end
        matching &&= expected
      end
      
      # check :primary_key
      unless opts[:primary_key].nil?
        _v = _convert_value(opts[:primary_key])
        expected = (col[1][:primary_key] === _v)
        conf_msg << "primary_key: '#{opts[:primary_key]}'"
        unless expected
          err_msg << "primary_key: '#{col[1][:primary_key]}'"
        end
        matching &&= expected
      end
      
      # check :auto_increment
      unless opts[:auto_increment].nil?
        _v = _convert_value(opts[:auto_increment])
        expected = (col[1][:auto_increment] === _v)
        conf_msg << "auto_increment: '#{opts[:auto_increment]}'" 
        unless expected
          err_msg << "auto_increment: '#{col[1][:auto_increment]}'"
        end
        matching &&= expected
      end
      
      msg = msg << " with: { #{conf_msg.join(', ')} } but found: { #{err_msg.join(', ')} }"
      assert matching, msg
      
    end
    
    def assert_association_one_to_one(obj, attribute, opts={}, msg=nil)
      assert_association(obj.class, :one_to_one, attribute, opts, msg)
    end
  
    def assert_association_one_to_many(obj, attribute, opts={}, msg=nil)
      assert_association(obj.class, :one_to_many, attribute, opts, msg)
    end
  
    def assert_association_many_to_one(obj, attribute, opts={}, msg=nil)
      assert_association(obj.class, :many_to_one, attribute, opts, msg)
    end
  
    def assert_association_many_to_many(obj, attribute, opts={}, msg=nil)
      assert_association(obj.class, :many_to_many, attribute, opts, msg)
    end
  
    def assert_association(klass, association_type, attribute, opts={}, msg=nil)
      msg = msg.nil? ? '' : "#{msg}\n"
      msg << "Expected #{klass.inspect} to have a #{association_type.inspect} association #{attribute.inspect}"
      assoc = klass.association_reflection(attribute) || {}
      if assoc.empty?
        msg << " but no association '#{attribute.inspect}' was found"
        arr = []
        klass.associations.each do |a|
          o = klass.association_reflection(a)
          if o[:type] == :many_to_many
            arr << { attribute: o[:name], type: o[:type], class: o[:class_name].to_sym, join_table: o[:join_table], left_keys: o[:left_keys], right_keys: o[:right_keys] }
          else
            arr << { attribute: o[:name], type: o[:type], class: o[:class_name].to_sym, keys: o[:keys] }
          end
        end
        msg << " - \navailable associations are: [ #{arr.join(', ')} ]\n"
        assert false, msg
      else
        matching = assoc[:type] == association_type
        err_msg = []; conf_msg = []
        opts.each { |key, value|
          conf_msg << { key => value } 
          if assoc[key]!= value
            err_msg << { key => assoc[key] }
            matching = false
          end
        }
        msg << " with given options: #{conf_msg.join(', ')} but should be #{err_msg.join(', ')}"
        assert matching, msg
      end
    end
    private 
    
    def _convert_value(val)
      _v = case val
            when :nil
              nil
            when :false
              false
            when :true
              true
            else
              val
           end
      _v
    end
  end
  
  module Assertions
    include Minitest::Sequel
  end
  
end
