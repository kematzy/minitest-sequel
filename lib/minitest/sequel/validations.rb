require 'minitest/sequel'

# reopening to add validations functionality
module Minitest::Assertions
  
  # Test for validating presence of a model attribute
  # 
  #     it { assert_validates_presence(model, :title) }
  #     it { model.must_validate_presence_of(:title, { message: '...' }) }
  # 
  def assert_validates_presence(obj, attribute, opts = {}, msg = nil)
    assert_validates(obj, :presence, attribute, opts, msg)
  end
  alias_method :assert_validates_presence_of, :assert_validates_presence
  
  # Test for validating the length of a model's attribute.
  # 
  # Available options:
  # 
  # * :message - The message to use (no default, overrides :nil_message, :too_long, :too_short, and :wrong_length options if present)
  # * :nil_message - The message to use use if :maximum option is used and the value is nil (default: 'is not present')
  # 
  # * :too_long - The message to use use if it the value is too long (default: 'is too long')
  # 
  # * :too_short - The message to use use if it the value is too short (default: 'is too short')
  # 
  # * :wrong_length - The message to use use if it the value is not valid (default: 'is the wrong length')
  # 
  # Size related options:
  # 
  # * :is - The exact size required for the value to be valid (no default)
  # 
  # * :minimum - The minimum size allowed for the value (no default)
  # 
  # * :maximum - The maximum size allowed for the value (no default)
  #
  # * :within - The array/range that must include the size of the value for it to be valid (no default)
  # 
  # 
  #     it { assert_validates_length(model, :title, { maximum: 12 }) }
  #     it { model.must_validate_length_of(:title, { within: 4..12 }) }
  # 
  def assert_validates_length(obj, attribute, opts = {}, msg = nil)
    assert_validates(obj, :length, attribute, opts, msg)
  end
  alias_method :assert_validates_length_of, :assert_validates_length
  
  # Test for validating the exact length of a model's attribute.
  # 
  #     it { assert_validates_exact_length(model, :title, 12, { message: '...' }) }
  #     it { model.must_validate_exact_length_of(:title, 12, { message: '...' }) }
  # 
  def assert_validates_exact_length(obj, attribute, exact_length, opts = {}, msg = nil)
    opts.merge!({ is: exact_length })
    assert_validates(obj, :length, attribute, opts, msg)
  end
  alias_method :assert_validates_exact_length_of, :assert_validates_exact_length
  
  # Test for validating the exact length of a model's attribute.
  # 
  #     it { assert_validates_length_range(model, :title, 4..12, { message: '...' }) }
  #     it { model.must_validate_length_range_of(:title, 4..12, { message: '...' }) }
  # 
  def assert_validates_length_range(obj, attribute, range, opts = {}, msg = nil)
    opts.merge!({ within: range })
    assert_validates(obj, :length, attribute, opts, msg)
  end
  alias_method :assert_validates_length_range_of, :assert_validates_length_range
  
  # Test for validating the maximum length of a model's attribute.
  # 
  #     it { assert_validates_max_length(model, :title, 12, { message: '...' }) }
  #     it { model.must_validate_max_length_of(:title, 12, { message: '...' }) }
  # 
  def assert_validates_max_length(obj, attribute, max_length, opts = {}, msg = nil)
    opts.merge!({ maximum: max_length })
    assert_validates(obj, :length, attribute, opts, msg)
  end
  alias_method :assert_validates_max_length_of, :assert_validates_max_length

  # Test for validating the minimum length of a model's attribute.
  # 
  #     it { assert_validates_min_length(model, :title, 12, { message: '...' }) }
  #     it { model.must_validate_min_length_of(:title, 12, { message: '...' }) }
  # 
  def assert_validates_min_length(obj, attribute, min_length, opts = {}, msg = nil)
    opts.merge!({ minimum: min_length })
    assert_validates(obj, :length, attribute, opts, msg)
  end
  alias_method :assert_validates_min_length_of, :assert_validates_min_length
  
  # Test for validating the format of a model's attribute with a regexp.
  # 
  #     it { assert_validates_format(model, :title, 12, { with: /[a-z+]/ }) }
  #     it { model.must_validate_format_of(:title, 12, { with: /[a-z]+/ }) }
  # 
  def assert_validates_format(obj, attribute, opts = {}, msg = nil)
    assert_validates(obj, :format, attribute, opts, msg)
  end
  alias_method :assert_validates_format_of, :assert_validates_format
  
  # Test for validating that a model's attribute is within a specified range or set of values.
  # 
  #     it { assert_validates_inclusion(model, :status, { in: [:a, :b, :c] }) }
  #     it { model.must_validate_inclusion_of(:status, { in: [:a, :b, :c] }) }
  # 
  def assert_validates_inclusion(obj, attribute, opts = {}, msg = nil)
    assert_validates(obj, :inclusion, attribute, opts, msg)
  end
  alias_method :assert_validates_inclusion_of, :assert_validates_inclusion
  
  # Test for validating that a a model's attribute is an integer.
  # 
  #     it { assert_validates_integer(model, :author_id, { message: '...' }) }
  #     it { model.must_validate_integer_of(:author_id, { message: '...' }) }
  # 
  def assert_validates_integer(obj, attribute, opts = {}, msg = nil)
    opts.merge!({ only_integer: true })
    assert_validates(obj, :numericality, attribute, opts, msg)
  end
  
  # Test for validating that a model's attribute is numeric (number).
  # 
  #     it { assert_validates_numericality(model, :author_id, { message: '...' }) }
  #     it { model.must_validate_numericality_of(:author_id, { message: '...' }) }
  # 
  def assert_validates_numericality(obj, attribute, opts = {}, msg = nil)
    assert_validates(obj, :numericality, attribute, opts, msg)
  end
  alias_method :assert_validates_numericality_of, :assert_validates_numericality
  
  # Test for validating that a model's attribute is unique.
  # 
  #     it { assert_validates_uniqueness(model, :urlslug, { message: '...' }) }
  #     it { model.must_validate_uniqueness_of(:urlslug, { message: '...' }) }
  # 
  def assert_validates_uniqueness(obj, attribute, opts = {}, msg = nil)
    assert_validates(obj, :uniqueness, attribute, opts, msg)
  end
  alias_method :assert_validates_uniqueness_of, :assert_validates_uniqueness
  
  # Validates acceptance of an attribute. Just checks that the value is equal to the :accept option. This method is unique in that :allow_nil is assumed to be true instead of false.
  
  # Test for validating the acceptance of a model's attribute.
  # 
  #     it { assert_validates_acceptance(Order.new, :toc, { message: '...' }) }
  #     it { model.must_validate_acceptance_of(:toc, { message: '...' }) }
  # 
  def assert_validates_acceptance(obj, attribute, opts = {}, msg = nil)
    assert_validates(obj, :acceptance, attribute, opts, msg)
  end
  alias_method :assert_validates_acceptance_of, :assert_validates_acceptance
  
  # Test for validating the confirmation of a model's attribute.
  # 
  #     it { assert_validates_confirmation(User.new, :password, { message: '...' }) }
  #     it { User.new.must_validate_confirmation_of(:password, { message: '...' }) }
  # 
  def assert_validates_confirmation(obj, attribute, opts = {}, msg = nil)
    assert_validates(obj, :confirmation, attribute, opts, msg)
  end
  alias_method :assert_validates_confirmation_of, :assert_validates_confirmation
  
  # 
  def assert_validates(obj, validation_type, attribute, opts = {}, msg = nil, &blk) 
    msg = msg.nil? ? '' : "#{msg}\n"
    err_msg  = []
    conf_msg = []
    unless obj.respond_to?(attribute)
      assert(false, "Column :#{attribute} is not defined in #{obj.class.to_s}")
    end
    
    msg << "Expected #{obj.class} to validate :#{validation_type} for :#{attribute} column"
    
    if _validated_model?(obj)
      
      if _validated_column?(obj, attribute)
        
        # checks if the model column is validated by the validation type 
        if _validated_with_validation_type?(obj, attribute, validation_type)
          matching = true
          
          # bail out if options provided are invalid
          val_opts = _valid_validation_options(validation_type)
          
          invalid_opts  = opts.keys.reject { |o| val_opts.include?(o) }
          unless invalid_opts.empty?
            msg << ", but the following invalid option(s) was found: { "
            invalid_opts.each { |o| msg << "#{o.inspect}; " }
            msg << " }. Valid options are: #{val_opts.inspect}"
            assert(false, msg)
          end
          
          h = _validation_types_hash_for_column(obj, attribute)
          _available_validation_options.each do |ov|
            unless opts[ov].nil?
              expected = (h[validation_type][ov].to_s == opts[ov].to_s)
               conf_msg << "#{ov}: '#{opts[ov]}'"
              unless expected
                err_msg << "#{ov}: '#{h[validation_type][ov]}'"
              end
              matching &&= expected
            end
          end
          
          msg = msg << " with: { #{conf_msg.join(', ')} }" unless conf_msg.empty?
          msg << " but found: { #{err_msg.join(', ')} }" unless err_msg.empty?
          assert(matching, msg)
          
        else
          msg << ", but no :#{validation_type} validation is defined for :#{attribute}"
          assert(false, msg)
        end
      else
        msg << ", but no validations are defined for :#{attribute}"
        assert(false, msg)
      end
    else
      assert(false, "No validations defined in #{obj.class.to_s}")
    end
  end
  
  
  # Test for validating presence of a model attribute
  # 
  #     it { refute_validates_presence(model, :title) }
  #     it { model.must_validate_presence_of(:title, { message: '...' }) }
  # 
  def refute_validates_presence(obj, attribute, opts = {}, msg = nil)
    refute_validates(obj, :presence, attribute, opts, msg)
  end
  alias_method :refute_validates_presence_of, :refute_validates_presence
  
  # Test for validating the length of a model's attribute.
  # 
  # Available options:
  # 
  # :message     ::  The message to use (no default, overrides :nil_message, :too_long, 
  #                  :too_short, and :wrong_length options if present)
  # 
  # :nil_message ::  The message to use use if :maximum option is used and the value is nil 
  #                  (default: 'is not present')
  # 
  # :too_long    ::  The message to use use if it the value is too long (default: 'is too long')
  # 
  # :too_short   ::  The message to use use if it the value is too short 
  #                  (default: 'is too short')
  # 
  # :wrong_length :: The message to use use if it the value is not valid 
  #                   (default: 'is the wrong length')
  # 
  # SIZE RELATED OPTIONS:
  # 
  # :is         :: The exact size required for the value to be valid (no default)
  # :minimum    :: The minimum size allowed for the value (no default)
  # :maximum    :: The maximum size allowed for the value (no default)
  # :within     :: The array/range that must include the size of the value for it to be valid 
  #                 (no default)
  # 
  #     it { refute_validates_length(model, :title, { maximum: 12 }) }
  #     it { model.must_validate_length_of(:title, { within: 4..12 }) }
  # 
  def refute_validates_length(obj, attribute, opts = {}, msg = nil)
    refute_validates(obj, :length, attribute, opts, msg)
  end
  alias_method :refute_validates_length_of, :refute_validates_length
  
  # Test for validating the exact length of a model's attribute.
  # 
  #     it { refute_validates_exact_length(model, :title, 12, { message: '...' }) }
  #     it { model.must_validate_exact_length_of(:title, 12, { message: '...' }) }
  # 
  def refute_validates_exact_length(obj, attribute, exact_length, opts = {}, msg = nil)
    opts.merge!({ is: exact_length })
    refute_validates(obj, :length, attribute, opts, msg)
  end
  alias_method :refute_validates_exact_length_of, :refute_validates_exact_length
  
  # Test for validating the exact length of a model's attribute.
  # 
  #     it { refute_validates_length_range(model, :title, 4..12, { message: '...' }) }
  #     it { model.must_validate_length_range_of(:title, 4..12, { message: '...' }) }
  # 
  def refute_validates_length_range(obj, attribute, range, opts = {}, msg = nil)
    opts.merge!({ within: range })
    refute_validates(obj, :length, attribute, opts, msg)
  end
  alias_method :refute_validates_length_range_of, :refute_validates_length_range
  
  # Test for validating the maximum length of a model's attribute.
  # 
  #     it { refute_validates_max_length(model, :title, 12, { message: '...' }) }
  #     it { model.must_validate_max_length_of(:title, 12, { message: '...' }) }
  # 
  def refute_validates_max_length(obj, attribute, max_length, opts = {}, msg = nil)
    opts.merge!({ maximum: max_length })
    refute_validates(obj, :length, attribute, opts, msg)
  end
  alias_method :refute_validates_max_length_of, :refute_validates_max_length

  # Test for validating the minimum length of a model's attribute.
  # 
  #     it { refute_validates_min_length(model, :title, 12, { message: '...' }) }
  #     it { model.must_validate_min_length_of(:title, 12, { message: '...' }) }
  # 
  def refute_validates_min_length(obj, attribute, min_length, opts = {}, msg = nil)
    opts.merge!({ minimum: min_length })
    refute_validates(obj, :length, attribute, opts, msg)
  end
  alias_method :refute_validates_min_length_of, :refute_validates_min_length
  
  # Test for validating the format of a model's attribute with a regexp.
  # 
  #     it { refute_validates_format(model, :title, 12, { with: /[a-z+]/ }) }
  #     it { model.must_validate_format_of(:title, 12, { with: /[a-z]+/ }) }
  # 
  def refute_validates_format(obj, attribute, opts = {}, msg = nil)
    refute_validates(obj, :format, attribute, opts, msg)
  end
  alias_method :refute_validates_format_of, :refute_validates_format
  
  # Test for validating that a model's attribute is within a specified range or set of values.
  # 
  #     it { refute_validates_inclusion(model, :status, { in: [:a, :b, :c] }) }
  #     it { model.must_validate_inclusion_of(:status, { in: [:a, :b, :c] }) }
  # 
  def refute_validates_inclusion(obj, attribute, opts = {}, msg = nil)
    refute_validates(obj, :inclusion, attribute, opts, msg)
  end
  alias_method :refute_validates_inclusion_of, :refute_validates_inclusion
  
  # Test for validating that a a model's attribute is an integer.
  # 
  #     it { refute_validates_integer(model, :author_id, { message: '...' }) }
  #     it { model.must_validate_integer_of(:author_id, { message: '...' }) }
  # 
  def refute_validates_integer(obj, attribute, opts = {}, msg = nil)
    opts.merge!({ only_integer: true })
    refute_validates(obj, :numericality, attribute, opts, msg)
  end
  
  # Test for validating that a model's attribute is numeric (number).
  # 
  #     it { refute_validates_numericality(model, :author_id, { message: '...' }) }
  #     it { model.must_validate_numericality_of(:author_id, { message: '...' }) }
  # 
  def refute_validates_numericality(obj, attribute, opts = {}, msg = nil)
    refute_validates(obj, :numericality, attribute, opts, msg)
  end
  alias_method :refute_validates_numericality_of, :refute_validates_numericality
  
  # Test for validating that a model's attribute is unique.
  # 
  #     it { refute_validates_uniqueness(model, :urlslug, { message: '...' }) }
  #     it { model.must_validate_uniqueness_of(:urlslug, { message: '...' }) }
  # 
  def refute_validates_uniqueness(obj, attribute, opts = {}, msg = nil)
    refute_validates(obj, :uniqueness, attribute, opts, msg)
  end
  alias_method :refute_validates_uniqueness_of, :refute_validates_uniqueness
  
  # Validates acceptance of an attribute. Just checks that the value is equal to the :accept option. This method is unique in that :allow_nil is assumed to be true instead of false.
  
  # Test for validating the acceptance of a model's attribute.
  # 
  #     it { refute_validates_acceptance(Order.new, :toc, { message: '...' }) }
  #     it { model.must_validate_acceptance_of(:toc, { message: '...' }) }
  # 
  def refute_validates_acceptance(obj, attribute, opts = {}, msg = nil)
    refute_validates(obj, :acceptance, attribute, opts, msg)
  end
  alias_method :refute_validates_acceptance_of, :refute_validates_acceptance
  
  # Test for validating the confirmation of a model's attribute.
  # 
  #     it { refute_validates_confirmation(User.new, :password, { message: '...' }) }
  #     it { User.new.must_validate_confirmation_of(:password, { message: '...' }) }
  # 
  def refute_validates_confirmation(obj, attribute, opts = {}, msg = nil)
    refute_validates(obj, :confirmation, attribute, opts, msg)
  end
  alias_method :refute_validates_confirmation_of, :refute_validates_confirmation
  
  # 
  def refute_validates(obj, validation_type, attribute, opts = {}, msg = nil, &blk)
    msg = msg.nil? ? '' : "#{msg}\n"
    err_msg  = []
    conf_msg = []
    unless obj.respond_to?(attribute)
      assert(false, "Column :#{attribute} is not defined in #{obj.class.to_s}, so cannot be validated")
    end
    
    msg << "Expected #{obj.class} NOT to validate :#{attribute} with :#{validation_type}"
    
    if _validated_model?(obj)
      
      if _validated_column?(obj, attribute)
        msg << ", but the column :#{attribute} was validated with :#{validation_type}"
        assert(false, msg)
      else
        assert(true, msg)
      end
    else
      assert(false, "No validations defined in #{obj.class.to_s}")
    end
  end
  
  
  # 
  def assert_raises_validation_failed(obj)
    assert_raises(::Sequel::ValidationFailed) { obj.save }
  end
  alias_method :assert_fails_validation, :assert_raises_validation_failed
  
  private
  
  
  # 
  def _validated_model?(model)
   return (model.class.respond_to?(:has_validations?) && model.class.has_validations?)
  end
  
  # 
  def _validated_column?(model, attribute)
    return false unless _validated_model?(model)
    return model.class.validation_reflections.keys.include?(attribute.to_sym)
  end
  
  # 
  def _validated_with_validation_type?(model, attribute, validation_type)
    return false unless _validated_column?(model, attribute)
    return _validation_types_hash_for_column(model, attribute).keys.include?(validation_type)
  end
  
  # 
  def _validation_types_hash_for_column(model, attribute)
    h = {}
    model.class.validation_reflections[attribute].each { |c| h[c[0]] = c[1] }
    h
  end
  
  # 
  def _available_validation_types
    [:format, :length, :presence, :numericality, :confirmation, :acceptance, :inclusion, :uniqueness]
  end
  
  # 
  def _available_validation_options
    [
      :message, :if, :is, :in, :allow_blank, :allow_missing, :allow_nil, :accept, :with, :within,
      :only_integer, :maximum, :minimum, :nil_message, :too_long, :too_short, :wrong_length
    ]
  end
  
  # 
  def _valid_validation_options(type = nil)
    arr = [:message]
    case type.to_sym
    when :each
      # validates_each (*atts, &block)
      # Adds a validation for each of the given attributes using the supplied block. 
      [:allow_blank, :allow_missing, :allow_nil].each { |a| arr << a }
    when :acceptance
      # The value required for the object to be valid (default: '1')
      arr << :accept
    when :format
      # The regular expression to validate the value with (required).
      arr << :with
    when :inclusion
      # An array or range of values to check for validity (required)
      arr << :in
    when :numericality
      # Whether only integers are valid values (default: false)
      arr << :only_integer
    when :length
      # 
      # :message     ::  The message to use (no default, overrides :nil_message, :too_long, 
      #                  :too_short, and :wrong_length options if present)
      # 
      # :nil_message ::  The message to use use if :maximum option is used and the value is nil 
      #                  (default: 'is not present')
      # 
      # :too_long    ::  The message to use use if it the value is too long (default: 'is too long')
      # 
      # :too_short   ::  The message to use use if it the value is too short 
      #                  (default: 'is too short')
      # 
      # :wrong_length :: The message to use use if it the value is not valid 
      #                   (default: 'is the wrong length')
      # 
      # SIZE
      # :is         :: The exact size required for the value to be valid (no default)
      # :minimum    :: The minimum size allowed for the value (no default)
      # :maximum    :: The maximum size allowed for the value (no default)
      # :within     :: The array/range that must include the size of the value for it to be valid 
      #                 (no default)
      
      [ :is, :maximum, :minimum, :nil_message, :too_long, :too_short, :within, :wrong_length ]
      .each { |a| arr << a }
    else
      arr
    end unless type.nil?
    arr
  end
  
end


# add support for Spec syntax
module Minitest::Expectations
  infect_an_assertion :assert_validates,              :must_validate,                 :reverse
  infect_an_assertion :assert_validates_presence,     :must_validate_presence_of,     :reverse
  infect_an_assertion :assert_validates_format,       :must_validate_format_of,       :reverse
  
  infect_an_assertion :assert_validates_length,       :must_validate_length_of,       :reverse
  infect_an_assertion :assert_validates_exact_length, :must_validate_exact_length_of, :reverse
  infect_an_assertion :assert_validates_min_length,   :must_validate_min_length_of,   :reverse
  infect_an_assertion :assert_validates_max_length,   :must_validate_max_length_of,   :reverse
  infect_an_assertion :assert_validates_length_range, :must_validate_length_range_of, :reverse
  
  infect_an_assertion :assert_validates_integer,      :must_validate_integer_of,      :reverse
  infect_an_assertion :assert_validates_numericality, :must_validate_numericality_of, :reverse
  infect_an_assertion :assert_validates_confirmation, :must_validate_confirmation_of, :reverse
  infect_an_assertion :assert_validates_acceptance,   :must_validate_acceptance_of,   :reverse
  infect_an_assertion :assert_validates_inclusion,    :must_validate_inclusion_of,    :reverse
  infect_an_assertion :assert_validates_uniqueness,   :must_validate_uniqueness_of,   :reverse
  
  infect_an_assertion :assert_fails_validation,       :must_fail_validation,          :reverse
  
  
  infect_an_assertion :refute_validates,              :wont_validate,                 :reverse
  infect_an_assertion :refute_validates_presence,     :wont_validate_presence_of,     :reverse
  infect_an_assertion :refute_validates_format,       :wont_validate_format_of,       :reverse
  
  infect_an_assertion :refute_validates_length,       :wont_validate_length_of,       :reverse
  infect_an_assertion :refute_validates_exact_length, :wont_validate_exact_length_of, :reverse
  infect_an_assertion :refute_validates_min_length,   :wont_validate_min_length_of,   :reverse
  infect_an_assertion :refute_validates_max_length,   :wont_validate_max_length_of,   :reverse
  infect_an_assertion :refute_validates_length_range, :wont_validate_length_range_of, :reverse
  
  infect_an_assertion :refute_validates_integer,      :wont_validate_integer_of,      :reverse
  infect_an_assertion :refute_validates_numericality, :wont_validate_numericality_of, :reverse
  infect_an_assertion :refute_validates_confirmation, :wont_validate_confirmation_of, :reverse
  infect_an_assertion :refute_validates_acceptance,   :wont_validate_acceptance_of,   :reverse
  infect_an_assertion :refute_validates_inclusion,    :wont_validate_inclusion_of,    :reverse
  infect_an_assertion :refute_validates_uniqueness,   :wont_validate_uniqueness_of,   :reverse
  
end
