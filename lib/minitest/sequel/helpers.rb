require "minitest/sequel"

# reopening to add helpers functionality
class Minitest::Spec

  # Enables quick tests to ensure that the basic CRUD functionality is working correctly for a Model
  #
  #     let(:m) { User.make }
  #
  #     ensure_working_CRUD(User, :username)
  #
  # NOTE!
  #
  # * the passed `_model` argument must be the actual Model class and NOT a string or symbol
  # * the passed attribute `_attr` must be a String attribute or the tests will fail
  #
  # **DEPENDENCIES**
  #
  # this test depends upon being able to create a new model instance for each test via using
  # Sequel Factory's `#make()` method
  #
  def self.ensure_working_CRUD(model, attr)

    describe "a valid CRUD model" do

      it "can create a #{model}" do
        m = model.send(:make)
        assert_instance_of(_model, m, "CRUD:create - expected #{m.class} to be an instance of #{model}")
        assert_empty(m.errors, "CRUD:create - expected .errors to be empty, but was: [#{m.errors.inspect}]")
      end

      it "can read a #{model}" do
        m = model.send(:make)
        res = model.send :first
        assert_instance_of(model, m, "CRUD:read - expected #{res.class} to be an instance of #{model}")
        assert_equal(m, res, "CRUD:read - expected [#{m.inspect}] to equal [#{res.inspect}]")
      end

      it "can update a #{model}" do
        m = model.send(:make)
        tmp_str = "#{m.send(attr.to_sym)} Updated"
        res = model.send(:first)

        assert_equal(m, res, "CRUD:update - expected [#{m.inspect}] to equal [#{res.inspect}]")
        res.send("#{attr}=", tmp_str)
        res.save

        res2 = model.send(:first)
        assert_equal(tmp_str, res2.send(attr.to_sym), "CRUD:update - expected [#{res2.send(attr.to_sym)}] to equal the updated string: [#{tmp_str}]")
      end

      it "can destroy a #{model}" do
        m = model.send(:make)
        if m.respond_to?(:deleted_at)
          assert_nil(m.deleted_at, "CRUD:delete - expected m.deleted_at to be nil, but was [#{m.deleted_at}]")
        end
        assert(m.destroy, "CRUD:delete - expected m.destroy to return true")
        res = model.send(:first)
        assert_nil(res, "CRUD:delete - expected #{model}.first to return nil, but was: [#{res.inspect}]")
        if m.respond_to?(:deleted_at)
          refute_nil(m.deleted_at, "CRUD:delete - expected m.deleted_at to be NOT be nil")
          assert_instance_of(Time, m.deleted_at, "CRUD:delete - expected m.deleted_at to be an instance of Time")
        end
      end

    end
  end

end
