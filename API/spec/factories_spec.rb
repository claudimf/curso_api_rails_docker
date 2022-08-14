# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FactoryBot do
  it { FactoryBot.lint(traits: true) }
end