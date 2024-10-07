# frozen_string_literal: true

require_relative '../../../spec_helper'

class EnsureParanoidPost < Sequel::Model
  plugin :paranoid

  def self.make
    create(title: 'A Post')
  end
end

describe Minitest::Spec do
  describe '#ensure_paranoid_model(:model)' do
    describe 'a model with .plugin(:paranoid)' do
      describe EnsureParanoidPost do
        ensure_paranoid_model(EnsureParanoidPost)
      end
    end

    describe 'a model without .plugin(:paranoid)' do
      # ensure_paranoid_model(::Post)

      it 'TODO: requires some tests' do
        skip 'TODO: requires some tests'
        # assert(true)
      end
    end
    # /a model without .plugin(:paranoid)
  end
  # /#ensure_paranoid_model(:model)
end
