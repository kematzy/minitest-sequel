# frozen_string_literal: false

# reopening to add validations functionality
module Minitest
  # add support for Assert syntax
  module Assertions
    # Test for a :one_to_one association for the current model
    #
    # This method asserts that the given object has a one-to-one association
    # with the specified attribute and options.
    #
    # @param obj [Object] The object to test the association on
    # @param attribute [Symbol] The name of the association
    # @param opts [Hash] Additional options for the association (default: {})
    # @param msg [String] Custom error message (optional)
    #
    # @example Testing a one-to-one association
    #   let(:post) { Post.first }
    #
    #   it "has a one-to-one association with first_comment" do
    #     assert_association_one_to_one(post, :first_comment, { class: :Comment, order: :id })
    #   end
    #
    # @example Using expectation syntax
    #   it "has a one-to-one association with first_comment" do
    #     post.must_have_one_to_one_association(:first_comment, { class: :Comment, order: :id })
    #   end
    #
    # @return [Boolean] true if the assertion passes, raises an error otherwise
    #
    def assert_association_one_to_one(obj, attribute, opts = {}, msg = nil)
      assert_association(obj.class, :one_to_one, attribute, opts, msg)
    end

    # Test for a :one_to_many association for the current model
    #
    # This method asserts that the given object has a one-to-many association
    # with the specified attribute and options.
    #
    # @param obj [Object] The object to test the association on
    # @param attribute [Symbol] The name of the association
    # @param opts [Hash] Additional options for the association (default: {})
    # @param msg [String] Custom error message (optional)
    #
    # @example Testing a one-to-many association
    #   let(:post) { Post.first }
    #
    #   it "has a one-to-many association with comments" do
    #     assert_association_one_to_many(post, :comments)
    #   end
    #
    # @example Using expectation syntax
    #   it "has a one-to-many association with comments" do
    #     post.must_have_one_to_many_association(:comments)
    #   end
    #
    # @return [Boolean] true if the assertion passes, raises an error otherwise
    #
    def assert_association_one_to_many(obj, attribute, opts = {}, msg = nil)
      assert_association(obj.class, :one_to_many, attribute, opts, msg)
    end

    # Test for a :many_to_one association for the current model
    #
    # This method asserts that the given object has a many-to-one association
    # with the specified attribute and options.
    #
    # @param obj [Object] The object to test the association on
    # @param attribute [Symbol] The name of the association
    # @param opts [Hash] Additional options for the association (default: {})
    # @param msg [String] Custom error message (optional)
    #
    # @example Testing a many-to-one association
    #   let(:comment) { Comment.first }
    #
    #   it "has a many-to-one association with post" do
    #     assert_association_many_to_one(comment, :post)
    #   end
    #
    # @example Using expectation syntax
    #   it "has a many-to-one association with post" do
    #     comment.must_have_many_to_one_association(:post)
    #   end
    #
    # @return [Boolean] true if the assertion passes, raises an error otherwise
    #
    def assert_association_many_to_one(obj, attribute, opts = {}, msg = nil)
      assert_association(obj.class, :many_to_one, attribute, opts, msg)
    end

    # Test for a :many_to_many association for the current model
    #
    # This method asserts that the given object has a many-to-many association
    # with the specified attribute and options.
    #
    # @param obj [Object] The object to test the association on
    # @param attribute [Symbol] The name of the association
    # @param opts [Hash] Additional options for the association (default: {})
    # @param msg [String] Custom error message (optional)
    #
    # @example Testing a many-to-many association
    #   let(:post) { Post.first }
    #
    #   it "has a many-to-many association with tags" do
    #     assert_association_many_to_many(post, :tags)
    #   end
    #
    # @example Using expectation syntax
    #   it "has a many-to-many association with tags" do
    #     post.must_have_many_to_many_association(:tags)
    #   end
    #
    # @return [Boolean] true if the assertion passes, raises an error otherwise
    #
    def assert_association_many_to_many(obj, attribute, opts = {}, msg = nil)
      assert_association(obj.class, :many_to_many, attribute, opts, msg)
    end

    # Test for associations for the current model by passing the :association_type
    #
    # This method asserts that the given class has an association of the specified type
    # with the given attribute and options.
    #
    # @param klass [Class] The class to test the association on
    # @param association_type [Symbol] The type of association to check for (e.g., :many_to_many)
    # @param attribute [Symbol] The name of the association
    # @param opts [Hash] Additional options for the association (default: {})
    # @param msg [String] Custom error message (optional)
    #
    # @example Testing a many-to-many association
    #   it "has a many-to-many association with tags" do
    #     assert_association(Post, :many_to_many, :tags)
    #   end
    #
    # @example Testing an association with options
    #   it "has a one-to-many association with comments" do
    #     assert_association(Post, :one_to_many, :comments, { class: 'Comment', key: :post_id })
    #   end
    #
    # @return [Boolean] true if the assertion passes, raises an error otherwise
    #
    # rubocop:disable Metrics/*
    def assert_association(klass, association_type, attribute, opts = {}, msg = nil)
      # Initialize error message
      msg = msg.nil? ? '' : "#{msg}\n"
      msg << "Expected #{klass} to have a #{association_type.inspect}"
      msg << " association #{attribute.inspect}"

      # Get association reflection or empty hash if not found
      assoc = klass.association_reflection(attribute) || {}

      if assoc.empty?
        # Association not found, prepare error message with available associations
        msg << ", but no association '#{attribute.inspect}' was found"
        arr = []
        klass.associations.each do |a|
          o = klass.association_reflection(a)
          arr << if o[:type] == :many_to_many
                   # Prepare info for many-to-many association
                   {
                     attribute: o[:name],
                     type: o[:type],
                     class: o[:class_name].to_s,
                     join_table: o[:join_table],
                     left_keys: o[:left_keys],
                     right_keys: o[:right_keys]
                   }
                 else
                   # Prepare info for other association types
                   {
                     attribute: o[:name],
                     type: o[:type],
                     class: o[:class_name].to_s,
                     keys: o[:keys]
                   }
                 end
        end
        # /klass.associations.each

        msg << " - \navailable associations are: [ #{arr.join(', ')} ]\n"
        assert(false, msg)
      else
        # Association found, check if it matches the expected type
        matching = assoc[:type] == association_type
        err_msg = []
        conf_msg = []

        # Check each option against the association
        opts.each do |key, value|
          conf_msg << { key => value }
          if assoc[key] != value
            err_msg << { key => assoc[key].to_s }
            matching = false
          end
        end

        # Prepare error message with mismatched options
        msg << " with given options: #{conf_msg.join(', ')} but should be #{err_msg.join(', ')}"
        assert(matching, msg)
      end
    end
    # rubocop:enable Metrics/*

    # Test to ensure there is no :one_to_one association for the current model
    #
    # This method asserts that the given object does not have a one-to-one association
    # with the specified attribute.
    #
    # @param obj [Object] The object to test the association on
    # @param attribute [Symbol] The name of the association
    # @param msg [String] Custom error message (optional)
    #
    # @example Testing that an object does not have a one-to-one association
    #   let(:post) { Post.first }
    #
    #   it "does not have a one-to-one association with first_comment" do
    #     refute_association_one_to_one(post, :first_comment)
    #   end
    #
    # @example Using expectation syntax
    #   it "does not have a one-to-one association with first_comment" do
    #     post.wont_have_one_to_one_association(:first_comment)
    #   end
    #
    # @return [Boolean] true if the assertion passes, raises an error otherwise
    #
    def refute_association_one_to_one(obj, attribute, msg = nil)
      refute_association(obj.class, :one_to_one, attribute, msg)
    end

    # Test to ensure there is no :one_to_many association for the current model
    #
    # This method asserts that the given object does not have a one-to-many association
    # with the specified attribute.
    #
    # @param obj [Object] The object to test the association on
    # @param attribute [Symbol] The name of the association
    # @param msg [String] Custom error message (optional)
    #
    # @example Testing that an object does not have a one-to-many association
    #   let(:post) { Post.first }
    #
    #   it "does not have a one-to-many association with comments" do
    #     refute_association_one_to_many(post, :comments)
    #   end
    #
    # @example Using expectation syntax
    #   it "does not have a one-to-many association with comments" do
    #     post.wont_have_one_to_many_association(:comments)
    #   end
    #
    # @return [Boolean] true if the assertion passes, raises an error otherwise
    #
    def refute_association_one_to_many(obj, attribute, msg = nil)
      refute_association(obj.class, :one_to_many, attribute, msg)
    end

    # Test to ensure there is no :many_to_one association for the current model
    #
    # This method asserts that the given object does not have a many-to-one association
    # with the specified attribute.
    #
    # @param obj [Object] The object to test the association on
    # @param attribute [Symbol] The name of the association
    # @param msg [String] Custom error message (optional)
    #
    # @example Testing that an object does not have a many-to-one association
    #   let(:comment) { Comment.first }
    #
    #   it "does not have a many-to-one association with post" do
    #     refute_association_many_to_one(comment, :post)
    #   end
    #
    # @example Using expectation syntax
    #   it "does not have a many-to-one association with post" do
    #     comment.wont_have_many_to_one_association(:post)
    #   end
    #
    # @return [Boolean] true if the assertion passes, raises an error otherwise
    #
    def refute_association_many_to_one(obj, attribute, msg = nil)
      refute_association(obj.class, :many_to_one, attribute, msg)
    end

    # Test to ensure there is no :many_to_many association for the current model
    #
    # This method asserts that the given object does not have a many-to-many association
    # with the specified attribute.
    #
    # @param obj [Object] The object to test the association on
    # @param attribute [Symbol] The name of the association
    # @param msg [String] Custom error message (optional)
    #
    # @example Testing that an object does not have a many-to-many association
    #   let(:post) { Post.first }
    #
    #   it "does not have a many-to-many association with tags" do
    #     refute_association_many_to_many(post, :tags)
    #   end
    #
    # @example Using expectation syntax
    #   it "does not have a many-to-many association with tags" do
    #     post.wont_have_many_to_many_association(:tags)
    #   end
    #
    # @return [Boolean] true if the assertion passes, raises an error otherwise
    #
    def refute_association_many_to_many(obj, attribute, msg = nil)
      refute_association(obj.class, :many_to_many, attribute, msg)
    end

    # Test to ensure the current model does NOT have an association by type :association_type
    #
    # This method asserts that the given class does not have an association of the specified type
    # with the given attribute.
    #
    # @param klass [Class] The class to test the association on
    # @param association_type [Symbol] The type of association to check for (e.g., :many_to_many)
    # @param attribute [Symbol] The name of the association
    # @param msg [String] Custom error message (optional)
    #
    # @example Testing that a class does not have a many-to-many association
    #   it "does not have a many-to-many association with tags" do
    #     refute_association(Post, :many_to_many, :tags)
    #   end
    #
    # @example Using expectation syntax
    #   it "does not have a many-to-many association with tags" do
    #     Post.wont_have_association(:many_to_many, :tags)
    #   end
    #
    # @return [Boolean] true if the assertion passes, raises an error otherwise
    #
    # rubocop:disable Metrics/MethodLength
    def refute_association(klass, association_type, attribute, msg = nil)
      msg = msg.nil? ? '' : "#{msg}\n"
      msg << "Expected #{klass.inspect} to NOT have a #{association_type.inspect}"
      msg << " association #{attribute.inspect}"
      assoc = klass.association_reflection(attribute) || {}

      if assoc.empty?
        assert(true, msg)
      else
        matching = false if assoc[:type] == association_type
        msg << ', but such an association was found'
        assert(matching, msg)
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
  # /module Assertions

  # add support for Spec syntax
  # rubocop:disable Layout/LineLength
  module Expectations
    infect_an_assertion :assert_association,              :must_have_association,             :reverse
    infect_an_assertion :assert_association_one_to_one,   :must_have_one_to_one_association,  :reverse
    infect_an_assertion :assert_association_one_to_many,  :must_have_one_to_many_association, :reverse
    infect_an_assertion :assert_association_many_to_one,  :must_have_many_to_one_association, :reverse
    infect_an_assertion :assert_association_many_to_many, :must_have_many_to_many_association, :reverse

    infect_an_assertion :refute_association,              :wont_have_association,             :reverse
    infect_an_assertion :refute_association_one_to_one,   :wont_have_one_to_one_association,  :reverse
    infect_an_assertion :refute_association_one_to_many,  :wont_have_one_to_many_association, :reverse
    infect_an_assertion :refute_association_many_to_one,  :wont_have_many_to_one_association, :reverse
    infect_an_assertion :refute_association_many_to_many, :wont_have_many_to_many_association, :reverse
  end
  # rubocop:enable Layout/LineLength
end
