# frozen_string_literal: true

describe GrapeSwagger::FastJsonapi::Parser do
  subject { described_class }

  it { expect(subject.deprecated?).to be true }
end
