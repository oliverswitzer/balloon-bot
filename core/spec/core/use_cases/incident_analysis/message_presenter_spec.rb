require_relative '../../../spec_helper'

describe Core::IncidentAnalysis::MessagePresenter do
  describe '#cleaned_text' do
    context 'when text is valid' do
      let(:message) { Core::EntityFactory.build_message(text: 'some valid message') }

      subject { as_message_document(message) }

      it 'should return the text of the message' do
        expect(subject.cleaned_text).to eq('some valid message')
      end

      context 'cleaning the text' do
        context 'when the text contains "pop"' do
          let(:message) { Core::EntityFactory.build_message(text: 'pop some valid message') }

          subject { as_message_document(message) }

          it 'should filter out the word "pop"' do
            expect(subject.cleaned_text).not_to include('pop')
          end
        end
        context 'when the text contains anything between < and >"' do
          let(:message) { Core::EntityFactory.build_message(text: '< some stuff inside brackets> and outside') }

          subject { as_message_document(message) }

          it 'should filter out the word "pop"' do
            expect(subject.cleaned_text).not_to include('some stuff inside brackets')
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

          message_document = as_message_document(message)

          expect(message_document.cleaned_text).to eq(''), "Expected #{message.text} to be filtered out"
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
      let(:message) { Core::EntityFactory.build_message }

      it 'should return an empty string' do
        message.text = nil
        message_document = as_message_document(message)

        expect(message_document.cleaned_text).to eq(''), "Expected #{message.text} to be filtered out"
      end
    end
  end

  def as_message_document(message)
    Core::IncidentAnalysis::MessagePresenter.new(message: message)
  end
end
