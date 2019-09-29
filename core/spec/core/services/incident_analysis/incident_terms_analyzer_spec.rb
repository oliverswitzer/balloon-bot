require_relative '../../../spec_helper'

describe Core::IncidentAnalysis::IncidentTermsAnalyzer do
  let(:incident_1) { Core::EntityFactory.build_incident_with_messages }
  let(:incident_2) { Core::EntityFactory.build_incident_with_messages }
  let(:text_analyzer_spy) { spy("Clients::DataAnalysis::TfIdfTermsAnalyzer") }

  subject do
    Core::IncidentAnalysis::IncidentTermsAnalyzer.new(
      text_analyzer: text_analyzer_spy
    )
  end

  it 'passes aggregated and cleaned messages to the text analyzer' do
    expect(
      Core::IncidentAnalysis::TextCleaner
    ).to receive(:aggregated_text_for_incident)
      .with(incident_1)
      .ordered
      .and_return("some cleaned and aggregated text for incident 1")

    expect(
      Core::IncidentAnalysis::TextCleaner
    ).to receive(:aggregated_text_for_incident)
      .with(incident_2)
      .ordered
      .and_return("some cleaned and aggregated text for incident 2")

    expect(text_analyzer_spy).to receive(:top_terms_for_documents)
      .with(
        'some cleaned and aggregated text for incident 1',
        'some cleaned and aggregated text for incident 2'
      )
    .and_return([
      %w(some terms for incident 1),
      %w(some terms for incident 2)
    ])

    result = subject.compute_top_terms_for(incidents: [
      incident_1,
      incident_2
    ])

    expect(result).to contain_exactly(
      %w(some terms for incident 1),
      %w(some terms for incident 2)
    )
  end
end