require "minitest/sequel"

# reopening to add validations functionality
module Minitest::Assertions

  def assert_timestamped_model_instance(model, opts = {}, msg = nil)
    msg = msg.nil? ? "" : "#{msg}\n"
    model_class = model.class
    # m = model.create(opts)
    # 1. test for Timestamps plugin
    plugs = model_class.instance_variable_get("@plugins").map { |p| p.to_s }
    if plugs.include?("Sequel::Plugins::Timestamps")
      # 2. test for created_at / :updated_at columns
      model.must_have_column(:created_at)
      model.must_have_column(:updated_at)

      if opts[:updated]
        # 4. updated record
        model.created_at.must_be_instance_of(Time)
        model.updated_at.must_be_instance_of(Time)
      else
        # 3.  initial record
        model.created_at.must_be_instance_of(Time)
        proc {
          model.updated_at.must_be_nil
        }.wont_have_error
        # assert_no_error_raised { model.updated_at.must_be_instance_of(NilClass) }
      end

    else
      raise(Minitest::Assertion, "Not a .plugin(:timestamps) model, available plugins are: #{plugs.inspect}")
    end

  end


  #
  #
  def assert_timestamped_model(model, opts = {}, msg = nil)
    msg = msg.nil? ? "" : "#{msg}\n"
    m = model.create(opts)
    # model.instance_variable_get("@plugins").must_include('Sequel::Plugins::Timestamps', "Expected #{model} to be a .plugin(:timestamps) model")
    # assert_equal(plugs, 'debug')


    # 1. test for Timestamps plugin
    plugs = model.instance_variable_get("@plugins").map{ |p| p.to_s }
    if plugs.include?("Sequel::Plugins::Timestamps")
      # 2. test for created_at / :updated_at columns
      m.must_have_column(:created_at)
      m.must_have_column(:updated_at)

      # 3.  initial record
      m.created_at.must_be_instance_of(Time)
      m.updated_at.must_be_instance_of(NilClass)

      # 4. updated record
      m.title = "#{m.title} updated"
      m.save
      m.created_at.must_be_instance_of(Time)
      m.updated_at.must_be_instance_of(Time)

    else
      raise(Minitest::Assertion, "Not a .plugin(:timestamps) model, available plugins are: #{plugs.inspect}")
    end


    # m.errors.add(:plugin, "Expected #{model} to be a .plugin(:timestamps) model")


    # m = model.create(opts)
    # msg << "Expected #{model} to be a .plugin(:timestamps) model:\n"
    # after create
    # m.must_have_column(:created_at, {}, msg)
    # msg << "after create:\n"
    #
    # unless m.created_at.must_be_instance_of(Time, msg)
    #   msg << "- :created_at should be a timestamp, but was [#{m.created_at.inspect}];\n"
    # end
    #
    # unless m.updated_at.must_be_nil
    #   msg << "- :updated_at should be nil, but was [#{m.updated_at.inspect}]\n"
    # end
    # # before update
    # old_ts = m.created_at
    # sleep 1  # TODO: could this be converted to timecop or similar?
    # m.save  # trigger update
    # # after update
    # msg << "after an update: \n"
    # m.created_at.must_equal(old_ts, msg << "- :created_at should be unchanged;\n")
    # m.updated_at.must_be_instance_of(Time, msg << "- :updated_at should be a timestamp, but was [#{m.updated_at.inspect}];\n")
  end

  #
  #
  def assert_paranoid_model(model, opts = {}, msg = nil)
    msg = msg.nil? ? "" : "#{msg}\n"
    m  = model.create(opts)
    m1 = model.create(opts)

    msg << "Expected #{model} to be a .plugin(:paranoid) model:\n"
    m.deleted_at.must_be_nil(msg << "")

    # after update
    m.save
    m.deleted_at.must_be_nil

    # after delete
    m1.delete
    m1.deleted_at.must_be_nil

    # after destroy
    m.destroy
    m.deleted_at.must_be_instance_of(Time)

  end

  #
  #
  def assert_valid_model(model)
    assert model.valid?
    model.errors.must_be_empty
  end

end

# reopening to add plugins functionality
class Minitest::Spec

  #
  #
  def self.it_must_be_a_timestamped_model(model, &blk)

    describe "#{model}.plugin(:timestamps)" do
      before do
        instance_exec(&blk)
      end

      it "#:created_at should be a timestamp on a new record" do
        @m.created_at.must_be_instance_of(Time)
      end

      it "#:created_at should remain unchanged after an update" do
        old_ts = @m.created_at
        @m.created_at.must_be_instance_of(Time)

        sleep 1  # TODO: convert this with timecop or similar one day.
        @m.save
        @m.created_at.must_equal(old_ts)
      end

      it "#:updated_at should be NULL (empty) on a new record" do
        @m.updated_at.must_be_nil
      end

      it "#:created_at should be a timestamp on an updated record" do
        @m.save
        @m.updated_at.must_be_instance_of(Time)
      end

    end

  end
  #
  #
  def self.it_must_be_a_timestamped_model(model, &blk)

    describe "#{model}.plugin(:timestamps)" do
      before do
        instance_exec(&blk)
      end

      it "#:created_at should be a timestamp on a new record" do
        @m.created_at.must_be_instance_of(Time)
      end

      it "#:created_at should remain unchanged after an update" do
        old_ts = @m.created_at
        @m.created_at.must_be_instance_of(Time)

        sleep 1  # TODO: convert this with timecop or similar one day.
        @m.save
        @m.created_at.must_equal(old_ts)
      end

      it "#:updated_at should be NULL (empty) on a new record" do
        @m.updated_at.must_be_nil
      end

      it "#:created_at should be a timestamp on an updated record" do
        @m.save
        @m.updated_at.must_be_instance_of(Time)
      end

    end

  end

  #
  #
  def self.it_must_be_a_paranoid_model(model, &blk)

    describe "#{model}.plugin(:paranoid)" do
      before do
        instance_exec(&blk)
      end

      it "#:deleted_at should be NULL (empty) on a new record" do
        @m.deleted_at.must_be_nil
      end

      it "#:deleted_at should be NULL (empty) on an updated record" do
        @m.save
        @m.deleted_at.must_be_nil
      end

      it "#:deleted_at should be a timestamp on a destroy'ed record" do
        @m.destroy
        @m.deleted_at.must_be_instance_of(Time)
      end

      it "#:deleted_at should be NULL (empty) on a delete'd record" do
        @m.delete
        @m.deleted_at.must_be_nil
      end

    end

  end

  #
  #
  def self.verify_is_a_timestamped_model(model, opts = {})

    describe "a timestamped model with .plugin(:timestamps)" do

      # let (:m1) { _model.send(:make) }
      let (:m) { model.create(opts) }

      it "#:created_at should be a timestamp on a new record" do
        m.created_at.must_be_instance_of(Time)
      end

      it "#:created_at should remain unchanged after an update" do
        old_ts = m.created_at
        m.created_at.must_be_instance_of(Time)

        sleep 1  # TODO: convert this with timecop or similar one day.
        m.save
        m.created_at.must_equal(old_ts)
      end

      it "#:updated_at should be NULL (empty) on a new record" do
        m.updated_at.must_be_nil
      end

      it "#:created_at should be a timestamp on an updated record" do
        m.save
        m.updated_at.must_be_instance_of(Time)
      end

    end

  end

  #
  #
  def self.verify_is_a_valid_CRUD_model(model, attr, opts = {})

    describe "a valid CRUD model" do

      it "can create a #{model}" do
        # m = _model.send(:make)
        m = model.create(opts)
        m.must_be_instance_of(model)
        m.errors.must_be_empty
      end

      it "can read a #{model}" do
        # m = _model.send(:make)
        m   = model.create(opts)
        res = model.send :first
        res.must_be_instance_of(model)
        res.must_equal(m)
      end

      it "can update a #{model}" do
        # m   = _model.send :make
        m    = model.create(opts)
        str = "#{m.send(_attr.to_sym)} Updated"
        res = model.send :first

        res.must_equal(m)
        res.send("#{attr}=", str )
        res.save

        res2 = model.send :first
        res2.send(attr.to_sym).must_equal(str)
      end

      it "can destroy a #{model}" do
        # m = _model.send(:make)
        m = model.create(opts)

        m.deleted_at.must_be_nil
        m.destroy
        m.deleted_at.wont_be_nil
        m.deleted_at.must_be_instance_of(Time)
      end

    end

  end

  #
  #
  def self.verify_is_a_paranoid_model(model, opts = {})

    describe "a paranoid model with .plugin(:paranoid)" do

      let (:m) { model.create(opts) }

      it "#:deleted_at should be NULL (empty) on a new record" do
        m.deleted_at.must_be_nil
      end

      it "#:deleted_at should be NULL (empty) on an updated record" do
        m.save
        m.deleted_at.must_be_nil
      end

      it "#:deleted_at should be a timestamp on a destroy'ed record" do
        m.destroy
        m.deleted_at.must_be_instance_of(Time)
      end

      it "#:deleted_at should be NULL (empty) on a delete'd record" do
        m.delete
        m.deleted_at.must_be_nil
      end

    end

  end
  # end

end
