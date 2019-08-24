require_relative '../../spec_helper'

describe Core::Message do
  describe '#cleaned_message' do
    context 'when text is valid' do
      subject do
        Core::EntityFactory.build_message(
          text: 'some valid message'
        )
      end

      it 'should return the text of the message' do
        expect(subject.cleaned_message).to eq('some valid message')
      end

      context 'cleaning the text' do
        context 'when the text contains "pop"' do
          subject do
            Core::EntityFactory.build_message(
              text: 'pop some valid message'
            )
          end

          it 'should filter out the word "pop"' do
            expect(subject.cleaned_message).not_to include('pop')
          end
        end
        context 'when the text contains anything between < and >"' do
          subject do
            Core::EntityFactory.build_message(
              text: '< some stuff inside brackets> and outside'
            )
          end

          it 'should filter out the word "pop"' do
            expect(subject.cleaned_message).not_to include('some stuff inside brackets')
          end
        end
      end
    end

    context 'when text matches UNWANTED_MESSAGE_REGEX' do
      let(:invalid_messages) do
        [
          ':hivequeen: `[hivequeen/foo]`',
          ':rosie: `[rosie/foo]`'
        ]
      end

      it 'should return an empty string' do
        invalid_messages.each do |invalid_text|
          message = Core::EntityFactory.build_message(text: invalid_text)

          expect(message.cleaned_message).to eq(''), "Expected #{message.text} to be filtered out"
        end
      end
    end

    context 'when text is nil' do
      let(:invalid_messages) do
        [
          ':hivequeen: `[hivequeen/foo]`',
          ':rosie: `[rosie/foo]`'
        ]
      end

      it 'should return an empty string' do
        message = Core::EntityFactory.build_message
        message.text = nil

        expect(message.cleaned_message).to eq(''), "Expected #{message.text} to be filtered out"
      end
    end
  end
end
