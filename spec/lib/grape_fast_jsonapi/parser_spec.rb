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
      context 'when the serializer doesn\'t have any attributes' do
        let(:model) { AnotherBlogPostSerializer } # no attributes

        it 'return a hash defining the schema with empty attributes' do
          expect(subject).to eq({
            data: {
              type: :object,
              properties: {
                id: { type: :integer },
                type: { type: :string },
                attributes: {
                  type: :object,
                  properties: {}
                },
                relationships: {
                  type: :object,
                  properties: {
                    user: {
                      properties: {
                        data: {
                          properties: {
                            id: { type: :integer },
                            type: { type: :string }
                          },
                          type: :object,
                        }
                      },
                      type: :object,
                    }
                  }
                }
              },
              example: {
                id: 1,
                type: :blog_post,
                attributes: {
                },
                relationships: {
                  user: {
                    data: { id: 1, type: :user }
                  }
                }
              }
            }
          })
        end
      end
    end
  end
end
