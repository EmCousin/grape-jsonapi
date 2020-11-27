# frozen_string_literal: true

describe Grape::Formatter::FastJsonapi do
  subject { described_class }

  it { expect(subject.deprecated?).to be true }
end
