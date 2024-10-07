# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Spec do
  ensure_working_crud(Post, :title)
end
