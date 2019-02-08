# frozen_string_literal: true

describe Grape::Formatter::FastJsonapi do
  describe 'class methods' do
    let(:user) do
      User.new(id: 1, first_name: 'Chuck', last_name: 'Norris', password: 'supersecretpassword', email: 'chuck@norris.com')
    end
    let(:another_user) do
      User.new(id: 2, first_name: 'Bruce', last_name: 'Lee', password: 'supersecretpassword', email: 'bruce@lee.com')
    end
    let(:blog_post) do
      BlogPost.new(id: 1, title: "Blog Post title", body: "Blog post body")
    end

    describe '.call' do
      subject { described_class.call(object, env) }
      let(:env) { {} }

      context 'when the object is a string' do
        let(:object) { "I am a string" }

        it { is_expected.to eq object }
      end

      context 'when the object is serializable' do
        let(:user_serializer) { UserSerializer.new(object, {}) }
        let(:blog_post_serializer) { BlogPostSerializer.new(object, {}) }

        context 'when the object is a active serializable model instance' do
          let(:object) { user }

          it { is_expected.to eq ::Grape::Json.dump(user_serializer.serializable_hash) }
        end

        context 'when the object is an array of active serializable model instances' do
          let(:object) { [user, another_user] }

          it { is_expected.to eq ::Grape::Json.dump(user_serializer.serializable_hash) }

          context "when the array contains instances of different models" do
            let(:object) { [user, blog_post] }

            it 'returns an array of jsonapi serialialized objects' do
              expect(subject).to eq(::Grape::Json.dump([
                UserSerializer.new(user, {}).serializable_hash,
                BlogPostSerializer.new(blog_post, {}).serializable_hash
              ]))
            end
          end
        end

        context 'when the object is a Hash of plain values' do
          let(:object) { user.as_json }

          it { is_expected.to eq ::Grape::Json.dump(object) }
        end

        context 'when the object is a Hash with serializable object values' do
          let(:object) do
            {
              user: user,
              blog_post: blog_post
            }
          end

          it 'returns an hash of with jsonapi serialialized objects values' do
            expect(subject).to eq(::Grape::Json.dump({
              user: UserSerializer.new(user, {}).serializable_hash,
              blog_post: BlogPostSerializer.new(blog_post, {}).serializable_hash
            }))
          end
        end

        context 'when the object is nil' do
          let(:object) { nil }

          it { is_expected.to eq 'null' }
        end

        context 'when the object is a number' do
          let(:object) { 42 }

          it { is_expected.to eq '42' }
        end
      end
    end
  end
end