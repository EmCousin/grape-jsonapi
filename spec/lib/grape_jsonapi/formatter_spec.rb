# frozen_string_literal: true

describe Grape::Formatter::Jsonapi do
  describe 'class methods' do
    let(:user) do
      User.new(id: 1, first_name: 'Chuck', last_name: 'Norris', password: 'supersecretpassword', email: 'chuck@norris.com')
    end
    let(:another_user) do
      User.new(id: 2, first_name: 'Bruce', last_name: 'Lee', password: 'supersecretpassword', email: 'bruce@lee.com')
    end
    let(:blog_post) do
      BlogPost.new(id: 1, title: 'Blog Post title', body: 'Blog post body')
    end
    let(:admin) do
      UserAdmin.new(id: 1, first_name: 'Jean Luc', last_name: 'Picard', password: 'supersecretpassword', email: 'jeanluc@picard.com')
    end

    describe '.call' do
      subject { described_class.call(object, env) }
      let(:jsonapi_serializer_options) { nil }
      let(:meta) { { pagination: { page: 1, total: 2 } } }
      let(:links) { { self: 'https://example/org' } }
      let(:env) { { 'jsonapi_serializer_options' => jsonapi_serializer_options, 'meta' => meta, 'links' => links } }

      context 'when the object is a string' do
        let(:object) { 'I am a string' }
        let(:response) { ::Grape::Json.dump({ data: object, meta: meta, links: links }) }

        it { is_expected.to eq response }
      end

      context 'when the object is serializable' do
        let(:user_serializer) { UserSerializer.new(object, {}) }
        let(:another_user_serializer) { AnotherUserSerializer.new(object, {}) }
        let(:blog_post_serializer) { BlogPostSerializer.new(object, {}) }

        context 'when the object has a model_name defined' do
          let(:object) { admin }
          let(:response) { ::Grape::Json.dump(user_serializer.serializable_hash.merge(meta: meta, links: links)) }

          it { is_expected.to eq response }
        end

        context 'when the object is a active serializable model instance' do
          let(:object) { user }
          let(:response) { ::Grape::Json.dump(user_serializer.serializable_hash.merge(meta: meta, links: links)) }

          it { is_expected.to eq response }
        end

        context 'when the object is an array' do
          context 'when the object is an array of active serializable model instances' do
            let(:object) { [user, another_user] }
            let(:response) { ::Grape::Json.dump(user_serializer.serializable_hash.merge(meta: meta, links: links)) }

            it { is_expected.to eq response }
          end

          context 'when the array contains instances of different models' do
            let(:object) { [user, blog_post] }
            let(:response) do
              ::Grape::Json.dump({
                data: [
                  UserSerializer.new(user, {}).serializable_hash[:data],
                  BlogPostSerializer.new(blog_post, {}).serializable_hash[:data]
                ],
                meta: meta,
                links: links
              })
            end

            it 'returns an array of jsonapi serialialized objects' do
              expect(subject).to eq response
            end
          end

          context 'when the object is an empty array' do
            let(:object) { [] }

            it { is_expected.to eq({ data: [], meta: meta, links: links }.to_json) }
          end

          context 'when the object is an array of null objects' do
            let(:object) { [nil, nil] }

            it { is_expected.to eq({ data: [nil, nil], meta: meta, links: links }.to_json) }
          end
        end

        context 'when the object is a hash' do
          context 'when the object is an empty hash' do
            let(:object) { {} }

            it { is_expected.to eq({ data: {}, meta: meta, links: links }.to_json) }
          end

          context 'when the object is a Hash of plain values' do
            let(:object) { user.as_json }

            it { is_expected.to eq ::Grape::Json.dump({ data: user.as_json, meta: meta, links: links }) }
          end

          context 'when the object is a Hash with serializable object values' do
            let(:object) do
              { user: user, blog_post: blog_post }
            end

            let(:response) do
              ::Grape::Json.dump({
                data: {
                  user: UserSerializer.new(user, {}).serializable_hash[:data],
                  blog_post: BlogPostSerializer.new(blog_post, {}).serializable_hash[:data]
                },
                meta: meta,
                links: links
              })
            end

            it 'returns an hash of with jsonapi serialialized objects values' do
              expect(subject).to eq response
            end
          end
        end

        context 'when the object is nil' do
          let(:object) { nil }

          it { is_expected.to eq({ data: nil, meta: meta, links: links }.to_json) }
        end

        context 'when the object is a number' do
          let(:object) { 42 }

          it { is_expected.to eq({ data: 42, meta: meta, links: links }.to_json) }
        end

        context 'when a custom serializer is passed as an option' do
          let(:object) { user }
          let(:jsonapi_serializer_options) do
            {
              'serializer' => '::AnotherUserSerializer'
            }
          end

          it { is_expected.to eq ::Grape::Json.dump(another_user_serializer.serializable_hash.merge(meta: meta, links: links)) }
        end
      end
    end
  end
end
