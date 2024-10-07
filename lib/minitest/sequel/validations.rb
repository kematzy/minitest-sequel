# frozen_string_literal: false

# reopening to add validations functionality
module Minitest
  # add support for Assert syntax
  # rubocop:disable Metrics/ModuleLength
  module Assertions
    # Test for validating presence of a model attribute
    #
    # This method checks if the specified attribute of the given object
    # has a presence validation. It can be used in both assertion and
    # expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for presence validation
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Using assertion style
    #   assert_validates_presence(model, :title)
    #
    # @example Using expectation style
    #   model.must_validate_presence_of(:title)
    #
    # @example With custom error message
    #   assert_validates_presence(model, :title, { message: 'Title cannot be blank' })
    #
    def assert_validates_presence(obj, attribute, opts = {}, msg = nil)
      assert_validates(obj, :presence, attribute, opts, msg)
    end
    alias assert_validates_presence_of assert_validates_presence

    # Test for validating the length of a model's attribute.
    #
    # This method checks if the specified attribute of the given object
    # has a length validation. It can be used in both assertion and
    # expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for length validation
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # Available options:
    #
    # * :message - The message to use (no default, overrides :nil_message, :too_long,
    #               :too_short, and :wrong_length options if present)
    # * :nil_message - The message to use if :maximum option is used and the value is nil
    #     (default: 'is not present')
    # * :too_long - The message to use if the value is too long (default: 'is too long')
    # * :too_short - The message to use if the value is too short (default: 'is too short')
    # * :wrong_length - The message to use if the value is not valid
    #     (default: 'is the wrong length')
    #
    # Size related options:
    #
    # * :is - The exact size required for the value to be valid (no default)
    # * :minimum - The minimum size allowed for the value (no default)
    # * :maximum - The maximum size allowed for the value (no default)
    # * :within - The array/range that must include the size of value for the value (no default)
    #
    # @example Using assertion style
    #   assert_validates_length(model, :title, { maximum: 12 })
    #
    # @example Using expectation style
    #   model.must_validate_length_of(:title, { within: 4..12 })
    #
    def assert_validates_length(obj, attribute, opts = {}, msg = nil)
      assert_validates(obj, :length, attribute, opts, msg)
    end
    alias assert_validates_length_of assert_validates_length

    # Test for validating the exact length of a model's attribute.
    #
    # This method checks if the specified attribute of the given object
    # has a length validation for an exact length. It can be used in both
    # assertion and expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for exact length validation
    # @param exact_length [Integer] The exact length to validate against
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Using assertion style
    #   assert_validates_exact_length(
    #     model,
    #     :title,
    #     12,
    #     { message: 'Must be exactly 12 characters' }
    #   )
    #
    # @example Using expectation style
    #   model.must_validate_exact_length_of(
    #     :title,
    #     12,
    #     { message: 'Must be exactly 12 characters' }
    #   )
    #
    def assert_validates_exact_length(obj, attribute, exact_length, opts = {}, msg = nil)
      opts[:is] = exact_length
      assert_validates(obj, :length, attribute, opts, msg)
    end
    alias assert_validates_exact_length_of assert_validates_exact_length

    # Test for validating the length range of a model's attribute.
    #
    # This method checks if the specified attribute of the given object
    # has a length validation within a specified range. It can be used in both
    # assertion and expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for length range validation
    # @param range [Range] The range of acceptable lengths
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Using assertion style
    #   assert_validates_length_range(
    #     model,
    #     :title,
    #     4..12,
    #     { message: 'Title must be between 4 and 12 characters' }
    #   )
    #
    # @example Using expectation style
    #   model.must_validate_length_range_of(
    #     :title,
    #     4..12,
    #     { message: 'Title must be between 4 and 12 characters' }
    #   )
    #
    def assert_validates_length_range(obj, attribute, range, opts = {}, msg = nil)
      opts[:within] = range
      assert_validates(obj, :length, attribute, opts, msg)
    end
    alias assert_validates_length_range_of assert_validates_length_range

    # Test for validating the maximum length of a model's attribute.
    #
    # This method checks if the specified attribute of the given object
    # has a length validation with a maximum value. It can be used in both
    # assertion and expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for maximum length validation
    # @param max_length [Integer] The maximum length to validate against
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Using assertion style
    #   assert_validates_max_length(model, :title, 12, { message: 'Title is too long' })
    #
    # @example Using expectation style
    #   model.must_validate_max_length_of(:title, 12, { message: 'Title is too long' })
    #
    def assert_validates_max_length(obj, attribute, max_length, opts = {}, msg = nil)
      opts[:maximum] = max_length
      assert_validates(obj, :length, attribute, opts, msg)
    end
    alias assert_validates_max_length_of assert_validates_max_length

    # Test for validating the minimum length of a model's attribute.
    #
    # This method checks if the specified attribute of the given object
    # has a length validation with a minimum value. It can be used in both
    # assertion and expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for minimum length validation
    # @param min_length [Integer] The minimum length to validate against
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Using assertion style
    #   assert_validates_min_length(model, :title, 12, { message: 'Title is too short' })
    #
    # @example Using expectation style
    #   model.must_validate_min_length_of(:title, 12, { message: 'Title is too short' })
    #
    def assert_validates_min_length(obj, attribute, min_length, opts = {}, msg = nil)
      opts[:minimum] = min_length
      assert_validates(obj, :length, attribute, opts, msg)
    end
    alias assert_validates_min_length_of assert_validates_min_length

    # Test for validating the format of a model's attribute with a regexp.
    #
    # This method checks if the specified attribute of the given object
    # has a format validation with the provided regular expression. It can be used
    # in both assertion and expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for format validation
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @option opts [Regexp] :with The regular expression to validate against (required)
    #
    # @example Using assertion style
    #   assert_validates_format(model, :title, { with: /[a-z]+/ })
    #
    # @example Using expectation style
    #   model.must_validate_format_of(:title, { with: /[a-z]+/ })
    #
    # @example With custom error message
    #   assert_validates_format(
    #     model,
    #     :title,
    #     { with: /[a-z]+/, message: 'must contain only lowercase letters' }
    #   )
    #
    def assert_validates_format(obj, attribute, opts = {}, msg = nil)
      assert_validates(obj, :format, attribute, opts, msg)
    end
    alias assert_validates_format_of assert_validates_format

    # Test for validating that a model's attribute is within a specified range or set of values.
    #
    # This method checks if the specified attribute of the given object
    # has an inclusion validation with the provided set of values. It can be used
    # in both assertion and expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for inclusion validation
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @option opts [Array, Range] :in The set of valid values (required)
    #
    # @example Using assertion style
    #   assert_validates_inclusion(model, :status, { in: [:a, :b, :c] })
    #
    # @example Using expectation style
    #   model.must_validate_inclusion_of(:status, { in: [:a, :b, :c] })
    #
    # @example With custom error message
    #   assert_validates_inclusion(
    #     model,
    #     :status,
    #     { in: [:a, :b, :c], message: 'must be a valid status' }
    #   )
    #
    def assert_validates_inclusion(obj, attribute, opts = {}, msg = nil)
      assert_validates(obj, :inclusion, attribute, opts, msg)
    end
    alias assert_validates_inclusion_of assert_validates_inclusion

    # Test for validating that a model's attribute is an integer.
    #
    # This method checks if the specified attribute of the given object
    # has a numericality validation with the 'only_integer' option set to true.
    # It can be used in both assertion and expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for integer validation
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Using assertion style
    #   assert_validates_integer(model, :author_id, { message: 'must be an integer' })
    #
    # @example Using expectation style
    #   model.must_validate_integer_of(:author_id, { message: 'must be an integer' })
    #
    def assert_validates_integer(obj, attribute, opts = {}, msg = nil)
      opts[:only_integer] = true
      assert_validates(obj, :numericality, attribute, opts, msg)
    end

    # Test for validating that a model's attribute is numeric (number).
    #
    # This method checks if the specified attribute of the given object
    # has a numericality validation. It can be used in both assertion and
    # expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for numericality validation
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Using assertion style
    #   assert_validates_numericality(model, :price, { greater_than: 0 })
    #
    # @example Using expectation style
    #   model.must_validate_numericality_of(:price, { less_than_or_equal_to: 1000 })
    #
    # @example With custom error message
    #   assert_validates_numericality(
    #     model,
    #     :quantity,
    #     { only_integer: true, message: 'must be a whole number' }
    #   )
    #
    def assert_validates_numericality(obj, attribute, opts = {}, msg = nil)
      assert_validates(obj, :numericality, attribute, opts, msg)
    end
    alias assert_validates_numericality_of assert_validates_numericality

    # Test for validating that a model's attribute is unique.
    #
    # This method checks if the specified attribute of the given object
    # has a uniqueness validation. It can be used in both assertion and
    # expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for uniqueness validation
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Using assertion style
    #   assert_validates_uniqueness(model, :urlslug, { message: 'must be unique' })
    #
    # @example Using expectation style
    #   model.must_validate_uniqueness_of(:urlslug, { case_sensitive: false })
    #
    # @example With custom error message
    #   assert_validates_uniqueness(
    #     model,
    #     :email,
    #     { scope: :account_id, message: 'already taken for this account' }
    #   )
    #
    def assert_validates_uniqueness(obj, attribute, opts = {}, msg = nil)
      assert_validates(obj, :uniqueness, attribute, opts, msg)
    end
    alias assert_validates_uniqueness_of assert_validates_uniqueness

    # Validates acceptance of an attribute. Just checks that the value is equal to the :accept
    # option. This method is unique in that :allow_nil is assumed to be true instead of false.

    # Test for validating the acceptance of a model's attribute.
    #
    # This method checks if the specified attribute of the given object
    # has an acceptance validation. It can be used in both assertion and
    # expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for acceptance validation
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Using assertion style
    #   assert_validates_acceptance(
    #     Order.new,
    #     :toc,
    #     { message: 'You must accept the terms and conditions' }
    #   )
    #
    # @example Using expectation style
    #   model.must_validate_acceptance_of(:toc, { accept: 'yes' })
    #
    # @note The acceptance validation is typically used for checkboxes in web forms
    #       where the user needs to accept terms of service.
    #
    def assert_validates_acceptance(obj, attribute, opts = {}, msg = nil)
      assert_validates(obj, :acceptance, attribute, opts, msg)
    end
    alias assert_validates_acceptance_of assert_validates_acceptance

    # Test for validating the confirmation of a model's attribute.
    #
    # This method checks if the specified attribute of the given object
    # has a confirmation validation. It can be used in both assertion and
    # expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for confirmation validation
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Using assertion style
    #   assert_validates_confirmation(User.new, :password, { message: 'Passwords do not match' })
    #
    # @example Using expectation style
    #   User.new.must_validate_confirmation_of(:password, { message: 'Passwords do not match' })
    #
    # @note The confirmation validation is typically used for password fields
    #       where the user needs to enter the same password twice.
    #
    def assert_validates_confirmation(obj, attribute, opts = {}, msg = nil)
      assert_validates(obj, :confirmation, attribute, opts, msg)
    end
    alias assert_validates_confirmation_of assert_validates_confirmation

    # Base test for validations of a model, used mainly as a shortcut for other assertions
    #
    # This method checks if the specified attribute of the given object has the expected
    # validation type and options. It can be used to test various validation types such as
    # ;presence, :format, :length, etc.
    #
    # @param obj [Object] The model object to test
    # @param validation_type [Symbol] The type of validation to check
    #                                 (e.g., :presence, :format, :length)
    # @param attribute [Symbol] The attribute to check for validation
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Testing presence validation
    #   assert_validates(User.new, :presence, :name, { message: "can't be blank" })
    #
    # @example Testing length validation
    #   assert_validates(Post.new, :length, :title, { minimum: 5, maximum: 100 })
    #
    # @raise [Minitest::Assertion] If the validation does not match the expected criteria
    #
    # rubocop:disable Metrics/*
    def assert_validates(obj, validation_type, attribute, opts = {}, msg = nil)
      msg = msg.nil? ? '' : "#{msg}\n"
      err_msg  = []
      conf_msg = []

      unless obj.respond_to?(attribute)
        assert(false, "Column :#{attribute} is not defined in #{obj.class}")
      end

      msg << "Expected #{obj.class} to validate :#{validation_type} for :#{attribute} column"

      if _validated_model?(obj)
        if _validated_column?(obj, attribute)
          # checks if the model column is validated by the validation type
          if _validated_with_validation_type?(obj, attribute, validation_type)
            matching = true

            # bail out if options provided are invalid
            val_opts = _valid_validation_options(validation_type)

            invalid_opts = opts.keys.reject { |o| val_opts.include?(o) }
            unless invalid_opts.empty?
              msg << ', but the following invalid option(s) was found: { '
              invalid_opts.each { |o| msg << "#{o.inspect}; " }
              msg << " }. Valid options are: #{val_opts.inspect}"
              assert(false, msg)
            end

            h = _validation_types_hash_for_column(obj, attribute)
            _available_validation_options.each do |ov|
              next if opts[ov].nil?

              expected = (h[validation_type][ov].to_s == opts[ov].to_s)
              conf_msg << "#{ov}: '#{opts[ov]}'"
              err_msg << "#{ov}: '#{h[validation_type][ov]}'" unless expected
              matching &&= expected
            end

            msg <<= " with: { #{conf_msg.join(', ')} }" unless conf_msg.empty?
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
        assert(false, "No validations defined in #{obj.class}")
      end
    end
    # rubocop:enable Metrics/*

    # Test for refuting the presence validation of a model attribute
    #
    # This method checks if the specified attribute of the given object
    # does not have a presence validation. It can be used in both assertion
    # and expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for absence of presence validation
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Using assertion style
    #   refute_validates_presence(model, :title)
    #
    # @example Using expectation style
    #   model.wont_validate_presence_of(:title)
    #
    # @example With custom error message
    #   refute_validates_presence(model, :title, {}, "Title should not have presence validation")
    #
    def refute_validates_presence(obj, attribute, opts = {}, msg = nil)
      refute_validates(obj, :presence, attribute, opts, msg)
    end
    alias refute_validates_presence_of refute_validates_presence

    # Test for refuting the length validation of a model's attribute.
    #
    # This method checks if the specified attribute of the given object
    # does not have a length validation with the provided options. It can be used
    # in both assertion and expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for absence of length validation
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # Available options:
    #
    # :message     :: The message to use (no default, overrides :nil_message, :too_long,
    #                 :too_short, and :wrong_length options if present)
    # :nil_message :: The message to use if :maximum option is used and the value is nil
    #                 (default: 'is not present')
    # :too_long    :: The message to use if the value is too long (default: 'is too long')
    # :too_short   :: The message to use if the value is too short (default: 'is too short')
    # :wrong_length :: The message to use if the value is not valid
    #                   (default: 'is the wrong length')
    #
    # Size related options:
    #
    # :is         :: The exact size required for the value to be valid (no default)
    # :minimum    :: The minimum size allowed for the value (no default)
    # :maximum    :: The maximum size allowed for the value (no default)
    # :within     :: The array/range that must include the size of the value for it to be valid
    #                (no default)
    #
    # @example Using assertion style
    #   refute_validates_length(model, :title, { maximum: 12 })
    #
    # @example Using expectation style
    #   model.wont_validate_length_of(:title, { within: 4..12 })
    #
    # @example With custom error message
    #   refute_validates_length(
    #     model,
    #     :title,
    #     { maximum: 12 },
    #     "Title should not have length validation"
    #   )
    #
    def refute_validates_length(obj, attribute, opts = {}, msg = nil)
      refute_validates(obj, :length, attribute, opts, msg)
    end
    alias refute_validates_length_of refute_validates_length

    # Test for refuting the validation of exact length for a model's attribute.
    #
    # This method checks if the specified attribute of the given object
    # does not have a length validation for an exact length. It can be used in both
    # assertion and expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for absence of exact length validation
    # @param exact_length [Integer] The exact length to validate against
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Using assertion style
    #   refute_validates_exact_length(
    #     model,
    #     :title,
    #     12,
    #     { message: 'Must not be exactly 12 characters' }
    #   )
    #
    # @example Using expectation style
    #   model.wont_validate_exact_length_of(
    #     :title,
    #     12,
    #     { message: 'Must not be exactly 12 characters' }
    #   )
    #
    def refute_validates_exact_length(obj, attribute, exact_length, opts = {}, msg = nil)
      # opts.merge!(is: exact_length)
      opts[:is] = exact_length
      refute_validates(obj, :length, attribute, opts, msg)
    end
    alias refute_validates_exact_length_of refute_validates_exact_length

    # Test for refuting the validation of length range for a model's attribute.
    #
    # This method checks if the specified attribute of the given object
    # does not have a length validation within a specified range. It can be used in both
    # assertion and expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for absence of length range validation
    # @param range [Range] The range of lengths to validate against
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Using assertion style
    #   refute_validates_length_range(
    #     model,
    #     :title,
    #     4..12,
    #     { message: 'Title length must not be between 4 and 12 characters' }
    #   )
    #
    # @example Using expectation style
    #   model.wont_validate_length_range_of(
    #     :title,
    #     4..12,
    #     { message: 'Title length must not be between 4 and 12 characters' }
    #   )
    #
    def refute_validates_length_range(obj, attribute, range, opts = {}, msg = nil)
      opts[:within] = range
      refute_validates(obj, :length, attribute, opts, msg)
    end
    alias refute_validates_length_range_of refute_validates_length_range

    # Test for refuting the maximum length validation of a model's attribute.
    #
    # This method checks if the specified attribute of the given object
    # does not have a length validation with a maximum value. It can be used in both
    # assertion and expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for absence of maximum length validation
    # @param max_length [Integer] The maximum length to validate against
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Using assertion style
    #   refute_validates_max_length(
    #     model,
    #     :title,
    #     12,
    #     { message: 'Title should not have maximum length validation' }
    #   )
    #
    # @example Using expectation style
    #   model.wont_validate_max_length_of(
    #     :title,
    #     12,
    #     { message: 'Title should not have maximum length validation' }
    #   )
    #
    def refute_validates_max_length(obj, attribute, max_length, opts = {}, msg = nil)
      opts[:maximum] = max_length
      refute_validates(obj, :length, attribute, opts, msg)
    end
    alias refute_validates_max_length_of refute_validates_max_length

    # Test for refuting the minimum length validation of a model's attribute.
    #
    # This method checks if the specified attribute of the given object
    # does not have a length validation with a minimum value. It can be used in both
    # assertion and expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for absence of minimum length validation
    # @param min_length [Integer] The minimum length to validate against
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Using assertion style
    #   refute_validates_min_length(
    #     model,
    #     :title,
    #     12,
    #     { message: 'Title should not have minimum length validation' }
    #   )
    #
    # @example Using expectation style
    #   model.wont_validate_min_length_of(
    #     :title,
    #     12,
    #     { message: 'Title should not have minimum length validation' }
    #   )
    #
    def refute_validates_min_length(obj, attribute, min_length, opts = {}, msg = nil)
      opts[:minimum] = min_length
      refute_validates(obj, :length, attribute, opts, msg)
    end
    alias refute_validates_min_length_of refute_validates_min_length

    # Test for refuting the format validation of a model's attribute with a regexp.
    #
    # This method checks if the specified attribute of the given object
    # does not have a format validation with the provided regular expression. It can be used
    # in both assertion and expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for absence of format validation
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @option opts [Regexp] :with The regular expression to validate against (required)
    #
    # @example Using assertion style
    #   refute_validates_format(model, :title, { with: /[a-z]+/ })
    #
    # @example Using expectation style
    #   model.wont_validate_format_of(:title, { with: /[a-z]+/ })
    #
    # @example With custom error message
    #   refute_validates_format(
    #     model,
    #     :title,
    #     { with: /[a-z]+/ },
    #     "Title should not have format validation"
    #   )
    #
    def refute_validates_format(obj, attribute, opts = {}, msg = nil)
      refute_validates(obj, :format, attribute, opts, msg)
    end
    alias refute_validates_format_of refute_validates_format

    # Test for refuting the inclusion validation of a model's attribute.
    #
    # This method checks if the specified attribute of the given object
    # does not have an inclusion validation with the provided set of values. It can be used
    # in both assertion and expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for absence of inclusion validation
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @option opts [Array, Range] :in The set of valid values (required)
    #
    # @example Using assertion style
    #   refute_validates_inclusion(model, :status, { in: [:a, :b, :c] })
    #
    # @example Using expectation style
    #   model.wont_validate_inclusion_of(:status, { in: [:a, :b, :c] })
    #
    # @example With custom error message
    #   refute_validates_inclusion(
    #     model,
    #     :status,
    #     { in: [:a, :b, :c] },
    #     "Status should not be limited to these values"
    #   )
    #
    def refute_validates_inclusion(obj, attribute, opts = {}, msg = nil)
      refute_validates(obj, :inclusion, attribute, opts, msg)
    end
    alias refute_validates_inclusion_of refute_validates_inclusion

    # Test for refuting the validation that a model's attribute is an integer.
    #
    # This method checks if the specified attribute of the given object
    # does not have an integer validation. It can be used in both assertion
    # and expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for absence of integer validation
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Using assertion style
    #   refute_validates_integer(model, :author_id, { message: 'must not be an integer' })
    #
    # @example Using expectation style
    #   model.wont_validate_integer_of(:author_id, { message: 'must not be an integer' })
    #
    def refute_validates_integer(obj, attribute, opts = {}, msg = nil)
      opts[:only_integer] = true
      refute_validates(obj, :numericality, attribute, opts, msg)
    end

    # Test for refuting the numericality validation of a model's attribute.
    #
    # This method checks if the specified attribute of the given object
    # does not have a numericality validation. It can be used in both assertion
    # and expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for absence of numericality validation
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Using assertion style
    #   refute_validates_numericality(model, :price, { greater_than: 0 })
    #
    # @example Using expectation style
    #   model.wont_validate_numericality_of(:price, { less_than_or_equal_to: 1000 })
    #
    # @example With custom error message
    #   refute_validates_numericality(
    #     model,
    #     :quantity,
    #     { only_integer: true, message: 'must not be a number' }
    #   )
    #
    def refute_validates_numericality(obj, attribute, opts = {}, msg = nil)
      refute_validates(obj, :numericality, attribute, opts, msg)
    end
    alias refute_validates_numericality_of refute_validates_numericality

    # Test for refuting the uniqueness validation of a model's attribute.
    #
    # This method checks if the specified attribute of the given object
    # does not have a uniqueness validation. It can be used in both assertion
    # and expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for absence of uniqueness validation
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Using assertion style
    #   refute_validates_uniqueness(model, :urlslug, { message: 'should not be unique' })
    #
    # @example Using expectation style
    #   model.wont_validate_uniqueness_of(:urlslug, { case_sensitive: false })
    #
    # @example With custom error message
    #   refute_validates_uniqueness(
    #     model,
    #     :email,
    #     { scope: :account_id },
    #     "Email should not be unique within an account"
    #   )
    #
    def refute_validates_uniqueness(obj, attribute, opts = {}, msg = nil)
      refute_validates(obj, :uniqueness, attribute, opts, msg)
    end
    alias refute_validates_uniqueness_of refute_validates_uniqueness

    # Test for refuting the acceptance validation of a model's attribute.
    #
    # This method checks if the specified attribute of the given object
    # does not have an acceptance validation. It can be used in both assertion
    # and expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for absence of acceptance validation
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Using assertion style
    #   refute_validates_acceptance(Order.new, :toc, { message: 'should not require acceptance' })
    #
    # @example Using expectation style
    #   model.wont_validate_acceptance_of(:toc, { accept: 'yes' })
    #
    # @note The acceptance validation is typically used for checkboxes in web forms
    #       where the user needs to accept terms of service. This method ensures
    #       that such validation is not present.
    #
    def refute_validates_acceptance(obj, attribute, opts = {}, msg = nil)
      refute_validates(obj, :acceptance, attribute, opts, msg)
    end
    alias refute_validates_acceptance_of refute_validates_acceptance

    # Test for refuting the confirmation validation of a model's attribute.
    #
    # This method checks if the specified attribute of the given object
    # does not have a confirmation validation. It can be used in both assertion
    # and expectation styles.
    #
    # @param obj [Object] The model object to test
    # @param attribute [Symbol] The attribute to check for absence of confirmation validation
    # @param opts [Hash] Additional options for the validation (default: {})
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Using assertion style
    #   refute_validates_confirmation(
    #     User.new,
    #     :password,
    #     { message: 'should not require confirmation' }
    #   )
    #
    # @example Using expectation style
    #   User.new.wont_validate_confirmation_of(
    #     :password,
    #     { message: 'should not require confirmation' }
    #   )
    #
    # @note The confirmation validation is typically used for password fields
    #       where the user needs to enter the same password twice. This method
    #       ensures that such validation is not present.
    #
    def refute_validates_confirmation(obj, attribute, opts = {}, msg = nil)
      refute_validates(obj, :confirmation, attribute, opts, msg)
    end
    alias refute_validates_confirmation_of refute_validates_confirmation

    # Base test for refuting validations of a model
    #
    # This method checks if the specified attribute of the given object
    # does not have the specified validation type. It is used as a foundation
    # for other refutation assertions.
    #
    # @param obj [Object] The model object to test
    # @param validation_type [Symbol] The type of validation to check for absence
    # @param attribute [Symbol] The attribute to check for absence of validation
    # @param _opts [Hash] Additional options for the validation (unused in this method)
    # @param msg [String] Custom error message (default: nil)
    #
    # @example Refuting presence validation
    #   refute_validates(User.new, :presence, :name)
    #
    # @example Refuting length validation with custom message
    #   refute_validates(Post.new, :length, :title, {}, "Title should not have length validation")
    #
    # @raise [Minitest::Assertion] If the validation exists when it should not
    #
    # rubocop:disable Metrics/MethodLength
    def refute_validates(obj, validation_type, attribute, _opts = {}, msg = nil)
      msg = msg.nil? ? '' : "#{msg}\n"

      unless obj.respond_to?(attribute)
        assert(false, "Column :#{attribute} is not defined in #{obj.class}, so cannot be validated")
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
        assert(false, "No validations defined in #{obj.class}")
      end
    end
    # rubocop:enable Metrics/MethodLength

    # Test that saving an object raises a ValidationFailed error
    #
    # This method attempts to save the given object and asserts that it raises
    # a Sequel::ValidationFailed error. It can be used to test that invalid objects
    # fail validation when attempting to save.
    #
    # @param obj [Object] The model object to test
    #
    # @example Using assertion style
    #   assert_raises_validation_failed(invalid_user)
    #
    # @example Using expectation style
    #   invalid_user.must_fail_validation
    #
    # @raise [Minitest::Assertion] If saving the object does not raise Sequel::ValidationFailed
    #
    def assert_raises_validation_failed(obj)
      assert_raises(::Sequel::ValidationFailed) { obj.save }
    end
    alias assert_fails_validation assert_raises_validation_failed

    private

    # Check if the model has validations
    #
    # This method determines whether the given model class has any validations defined.
    #
    # @param model [Object] The model object to check for validations
    # @return [Boolean] True if the model has validations, false otherwise
    #
    # @example
    #   _validated_model?(User.new) #=> true
    #   _validated_model?(UnvalidatedModel.new) #=> false
    #
    def _validated_model?(model)
      model.class.respond_to?(:has_validations?) && model.class.has_validations?
    end

    # Check if a specific attribute of the model has validations
    #
    # This method determines whether the given attribute of the model has any validations defined.
    #
    # @param model [Object] The model object to check for validations
    # @param attribute [Symbol, String] The attribute to check for validations
    # @return [Boolean] True if the attribute has validations, false otherwise
    #
    # @example
    #   _validated_column?(User.new, :email) #=> true
    #   _validated_column?(User.new, :unvalidated_field) #=> false
    #
    def _validated_column?(model, attribute)
      return false unless _validated_model?(model)

      model.class.validation_reflections.key?(attribute.to_sym)
    end

    # Check if a specific attribute of the model has a specific validation type
    #
    # This method determines whether the given attribute of the model has the specified
    # validation type.
    #
    # @param model [Object] The model object to check for validations
    # @param attribute [Symbol, String] The attribute to check for validations
    # @param validation_type [Symbol] The type of validation to check for
    # @return [Boolean] True if the attribute has the specified validation type, false otherwise
    #
    # @example
    #   _validated_with_validation_type?(User.new, :email, :presence) #=> true
    #   _validated_with_validation_type?(User.new, :email, :format) #=> true
    #   _validated_with_validation_type?(User.new, :email, :length) #=> false
    #
    def _validated_with_validation_type?(model, attribute, validation_type)
      return false unless _validated_column?(model, attribute)

      _validation_types_hash_for_column(model, attribute).key?(validation_type)
    end

    # Get a hash of validation types and their options for a specific attribute
    #
    # This method creates a hash where the keys are validation types (e.g., :presence, :format)
    # and the values are the corresponding validation options for the specified attribute.
    #
    # @param model [Object] The model object to check for validations
    # @param attribute [Symbol, String] The attribute to get validations for
    # @return [Hash] A hash of validation types and their options
    #
    # @example
    #   _validation_types_hash_for_column(User.new, :email)
    #   #=> { presence: {}, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i } }
    #
    def _validation_types_hash_for_column(model, attribute)
      h = {}
      model.class.validation_reflections[attribute].each { |c| h[c[0]] = c[1] }
      h
    end

    # Get an array of available validation types
    #
    # This method returns an array of symbols representing the available
    # validation types in Sequel.
    #
    # @return [Array<Symbol>] An array of available validation type symbols
    #
    # @example
    #   _available_validation_types
    #   #=> [
    #     :format,
    #     :length,
    #     :presence,
    #     :numericality,
    #     :confirmation,
    #     :acceptance,
    #     :inclusion,
    #     :uniqueness
    #   ]
    #
    def _available_validation_types
      %i[format length presence numericality confirmation acceptance inclusion uniqueness]
    end

    # Get an array of available validation options
    #
    # This method returns an array of symbols representing the available
    # validation options in Sequel. These options can be used across
    # different validation types.
    #
    # @return [Array<Symbol>] An array of available validation option symbols
    #
    # @example
    #   _available_validation_options
    #   #=> [
    #     :message, :if, :is, :in, :allow_blank, :allow_missing, :allow_nil, :accept, :with,
    #     :within, :only_integer, :maximum, :minimum, :nil_message, :too_long, :too_short,
    #     :wrong_length
    #   ]
    #
    def _available_validation_options
      %i[
        message if is in allow_blank allow_missing allow_nil accept with within
        only_integer maximum minimum nil_message too_long too_short wrong_length
      ]
    end

    # Get valid validation options for a specific validation type
    #
    # This method returns an array of symbols representing the valid
    # validation options for a given validation type. If no type is specified,
    # it returns a base set of options common to all validation types.
    #
    # @param type [Symbol, nil] The validation type to get options for (default: nil)
    # @return [Array<Symbol>] An array of valid validation option symbols
    #
    # @example
    #   _valid_validation_options(:length)
    #   #=> [
    #     :message, :is, :maximum, :minimum, :nil_message,
    #     :too_long, :too_short, :within, :wrong_length
    #   ]
    #
    # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
    def _valid_validation_options(type = nil)
      arr = [:message]
      unless type.nil?
        case type.to_sym
        when :each
          # validates_each (*atts, &block)
          # Adds a validation for each of the given attributes using the supplied block.
          %i[allow_blank allow_missing allow_nil].each { |a| arr << a }
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
          # :message     ::  The message to use (no default, overrides :nil_message, :too_long,
          #                  :too_short, and :wrong_length options if present)
          # :nil_message ::  The message to use if :maximum option is used and the value is nil
          #                  (default: 'is not present')
          # :too_long    ::  The message to use if the value is too long (default: 'is too long')
          # :too_short   ::  The message to use if the value is too short
          #                  (default: 'is too short')
          # :wrong_length :: The message to use if the value is not valid
          #                   (default: 'is the wrong length')
          # :is         :: The exact size required for the value to be valid (no default)
          # :minimum    :: The minimum size allowed for the value (no default)
          # :maximum    :: The maximum size allowed for the value (no default)
          # :within     :: The array/range that must include size of the value for it to be valid
          #                 (no default)

          %i[is maximum minimum nil_message too_long too_short within wrong_length].each do |a|
            arr << a
          end
        else
          arr
        end
      end
      arr
    end
    # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity
  end
  # /module Assertions
  # rubocop:enable Metrics/ModuleLength

  # add support for Spec syntax
  module Expectations
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
end
