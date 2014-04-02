require_relative 'spec_helper'
require 'active_support/core_ext/string/strip'

describe Scanner, fakefs: true do
  
  selectors = {
    '#id_selector' => 1,
    '.class_selector' => 6
  }
  
  subject(:scanner) { Scanner.new(file) }
  
  let(:file) { File.open(filename, 'r') }
  let(:filename) { 'test_file.sass' }
  
  let(:file_content) do
    <<-END_SASS.strip_heredoc
      #id_selector
        border: 1px solid #ccc
        padding: 10px
        color: #333
      
      .class_selector
        float: left
        width: 600px
    END_SASS
  end
  
  
  
  before do
    File.write(filename, file_content)
  end

  after do
    file.close if !(!file || file.closed?)
    File.delete(filename)
  end

  it 'has a result which is a Hash' do
    expect(scanner.result).to be_a Hash
  end
  
  describe '#scan_sass' do
    let(:invoke) { scanner.scan_sass }

    it "adds the #{selectors.size} new selectors to the result" do
      expect { invoke }.to change { scanner.result.size }.by(selectors.size)
    end
    
    selectors.each do |selector, line_number|
      specify "the result's selector '#{selector}' has a '#{line_number}'" do
        invoke
        expect(scanner.result[selector]).to eq line_number
      end
    end # selectors array .each
  end

end
