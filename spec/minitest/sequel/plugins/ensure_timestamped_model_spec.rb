# frozen_string_literal: true

require_relative '../../../spec_helper'

class EnsureTimestampPost < Sequel::Model
  plugin :timestamps

  def self.make
    create(title: 'A Post')
  end
end

describe Minitest::Spec do
  describe '#ensure_timestamped_model(:model)' do
    describe 'a model with .plugin(:timestamps)' do
      describe EnsureTimestampPost do
        ensure_timestamped_model(EnsureTimestampPost)
      end

      it 'TODO: requires some more tests' do
        skip 'TODO: requires some tests'
        # assert(true)
      end
    end

    describe 'a model without .plugin(:timestamps)' do
      it 'TODO: requires some tests' do
        skip 'TODO: requires some tests'
        # assert(false)
      end
    end
    # /a model without .plugin(:paranoid)
  end
  # /#ensure_timestamped_model(:model)
end
