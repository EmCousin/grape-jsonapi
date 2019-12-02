# frozen_string_literal: true

describe GrapeSwagger::FastJsonapi::Parser do
  let(:model) { BlogPostSerializer }
  let(:endpoint) { '/' }

  describe 'attr_readers' do
    subject { described_class.new(model, endpoint) }

    it { expect(subject.model).to eq model }
    it { expect(subject.endpoint).to eq endpoint }
  end

  describe 'instance methods' do
    describe '#call' do
      subject { described_class.new(model, endpoint).call }

      it 'return a hash defining the schema' do
        expect(subject).to eq({
          data: {
            type: :object,
            properties: {
              id: { type: :integer },
              type: { type: :string },
              attributes: {
                type: :object,
                properties: {
                  title: { type: :string },
                  body: { type: :string }
                }
              },
              relationships: {
                type: :object,
                properties: {
                  user: {
                    type: :object,
                    properties: {
                      data: {
                        type: :object,
                        properties: {
                          id: { type: :integer },
                          type: { type: :string }
                        }
                      }
                    }
                  }
                }
              }
            },
            example: {
              id: 1,
              type: :blog_post,
              attributes: {
                title: "Example string",
                body: "Example string",
              },
              relationships: {
                user: {
                  data: {
                    id: 1,
                    type: :user
                  }
                }
              }
            }
          }
        })
      end

      context 'when the serializer contains sensitive information' do
        let(:model) { UserSerializer } # contains :password attribute

        it 'return a hash defining the schema filtering the sensitive attributes' do
          expect(subject).to eq({
            data: {
              type: :object,
              properties: {
                id: { type: :integer },
                type: { type: :string },
                attributes: {
                  type: :object,
                  properties: {
                    first_name: { type: :string },
                    last_name: { type: :string },
                    email: { type: :string },
                    # password: { type: :string }, FILTERED
                  }
                },
                relationships: {
                  type: :object,
                  properties: {
                    blog_posts: {
                      type: :object,
                      properties: {
                        data: {
                          type: :array,
                          items: {
                            type: :object,
                            properties: {
                              id: { type: :integer },
                              type: { type: :string }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              },
              example: {
                id: 1,
                type: :user,
                attributes: {
                  first_name: "Example string",
                  last_name: "Example string",
                  email: "Example string",
                  # password: "Example string", FILTERED
                },
                relationships: {
                  blog_posts: {
                    data: [{ id: 1, type: :blog_post }]
                  }
                }
              }
            }
          })
        end
      end

      context 'when schema has an association with :key different than association name' do
        let(:model) { FooSerializer }

        it 'includes associations as defined by :key attributes' do
          expect(subject[:data][:properties][:relationships][:properties]).to include(:foo_bar, :foo_fizz, :foo_buzzes)
        end
      end

      context 'when serializer has additional schema specified' do
        let(:model) { FooSerializer }

        it 'is deep-merged into the returned schema' do
          expect(subject[:data][:example][:attributes]).to include(xyz: 'foobar')
        end
      end

      context 'when serializer has DB-backed model' do
        let(:model) { DbRecordSerializer }

        before { allow(SecureRandom).to receive(:uuid).and_return 'fakeuuid' }

        it 'contains examples for corresponding data types' do
          expect(subject[:data][:example][:attributes]).to include(
            string_attribute: be_a(String),
            uuid_attribute: 'fakeuuid',
            integer_attribute: be_a(Integer),
            text_attribute: be_a(String),
            datetime_attribute: satisfy { |val| Time.parse(val).is_a? Time },
            date_attribute: satisfy { |val| Date.parse(val).is_a? Date },
            boolean_attribute: be_a(TrueClass).or(be_a(FalseClass)),
            array_attribute: be_a(Array)
          )
        end
      end
    end
  end
end