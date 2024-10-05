# frozen_string_literal: false


# reopening to add association functionality
module Minitest::Assertions
  # Test for a :one_to_one association for the current model
  #
  #     let(:m) { Post.first }
  #
  #     it { assert_association_one_to_one(m, :first_comment, { class: :Comment, order: :id }) }
  #     it { m.must_have_one_to_one_association(:first_comment, { class: :Comment, order: :id }) }
  #
  def assert_association_one_to_one(obj, attribute, opts = {}, msg = nil)
    assert_association(obj.class, :one_to_one, attribute, opts, msg)
  end

  # Test for a :one_to_many association for the current model
  #
  #     let(:m) { Post.first }
  #
  #     it { assert_association_one_to_many(m, :comments) }
  #     it { m.must_have_one_to_many_association(:comments) }
  #
  def assert_association_one_to_many(obj, attribute, opts = {}, msg = nil)
    assert_association(obj.class, :one_to_many, attribute, opts, msg)
  end

  # Test for a :many_to_one association for the current model
  #
  #     let(:m) { Post.first }
  #
  #     it { assert_association_many_to_one(m, :author) }
  #     it { m.must_have_many_to_one_association(:author) }
  #
  def assert_association_many_to_one(obj, attribute, opts = {}, msg = nil)
    assert_association(obj.class, :many_to_one, attribute, opts, msg)
  end

  # Test for a :many_to_many association for the current model
  #
  #     let(:m) { Post.first }
  #
  #     it { assert_association_many_to_many(m, :tags) }
  #     it { m.must_have_many_to_many_association(:tags) }
  #
  def assert_association_many_to_many(obj, attribute, opts = {}, msg = nil)
    assert_association(obj.class, :many_to_many, attribute, opts, msg)
  end

  # Test for associations for the current model by passing the :association_type
  #
  #     it { assert_association(Post, :many_to_many, :tags) }
  #
  def assert_association(klass, association_type, attribute, opts = {}, msg = nil)
    msg = msg.nil? ? '' : "#{msg}\n"
    msg << "Expected #{klass.inspect} to have a #{association_type.inspect}"
    msg << " association #{attribute.inspect}"
    assoc = klass.association_reflection(attribute) || {}
    if assoc.empty?
      msg << " but no association '#{attribute.inspect}' was found"
      arr = []
      klass.associations.each do |a|
        o = klass.association_reflection(a)
        arr << if o[:type] == :many_to_many
                 {
                   attribute: o[:name],
                   type: o[:type],
                   class: o[:class_name].to_s,
                   join_table: o[:join_table],
                   left_keys: o[:left_keys],
                   right_keys: o[:right_keys]
                 }
               else
                 {
                   attribute: o[:name],
                   type: o[:type],
                   class: o[:class_name].to_s,
                   keys: o[:keys]
                 }
               end
      end
      msg << " - \navailable associations are: [ #{arr.join(', ')} ]\n"
      assert(false, msg)
    else
      matching = assoc[:type] == association_type
      err_msg = []
      conf_msg = []
      opts.each do |key, value|
        conf_msg << { key => value }
        if assoc[key] != value
          err_msg << { key => assoc[key].to_s }
          matching = false
        end
      end
      msg << " with given options: #{conf_msg.join(', ')} but should be #{err_msg.join(', ')}"
      assert(matching, msg)
    end
  end

  # Test to ensure there is no :one_to_one association for the current model
  #
  #     let(:m) { Post.first }
  #
  #     it { refute_association_one_to_one(m, :first_comment, { class: :Comment, order: :id }) }
  #     it { m.must_have_one_to_one_association(:first_comment, { class: :Comment, order: :id }) }
  #
  def refute_association_one_to_one(obj, attribute, msg = nil)
    refute_association(obj.class, :one_to_one, attribute, msg)
  end

  # Test to ensure there is no :one_to_many association for the current model
  #
  #     let(:m) { Post.first }
  #
  #     it { refute_association_one_to_many(m, :comments) }
  #     it { m.must_have_one_to_many_association(:comments) }
  #
  def refute_association_one_to_many(obj, attribute, msg = nil)
    refute_association(obj.class, :one_to_many, attribute, msg)
  end

  # Test to ensure there is no :many_to_one association for the current model
  #
  #     let(:m) { Post.first }
  #
  #     it { refute_association_many_to_one(m, :author) }
  #     it { m.must_have_many_to_one_association(:author) }
  #
  def refute_association_many_to_one(obj, attribute, msg = nil)
    refute_association(obj.class, :many_to_one, attribute, msg)
  end

  # Test to ensure there is no :many_to_many association for the current model
  #
  #     let(:m) { Post.first }
  #
  #     it { refute_association_many_to_many(m, :tags) }
  #     it { m.must_have_many_to_many_association(:tags) }
  #
  def refute_association_many_to_many(obj, attribute, msg = nil)
    refute_association(obj.class, :many_to_many, attribute, msg)
  end

  # Test to ensure the current model does NOT have an association by type :association_type
  #
  #     it { refute_association(Post, :many_to_many, :tags) }
  #
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
end

# add support for Spec syntax
module Minitest::Expectations
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
