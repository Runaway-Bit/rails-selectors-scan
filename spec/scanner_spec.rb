require_relative 'spec_helper'
require 'active_support/core_ext/string/strip'

describe Scanner, fakefs: true do
 
  subject(:scanner) { Scanner.new(input_file, output_file) }

  let(:input_file) { File.open(input_filename, 'r') }
  let(:input_filename) { 'test_file.sass' }
  let(:input_content) do
    <<-END_SASS.strip_heredoc
      #id_selector
        border: 1px solid #ccc
        padding: 10px
        color: #333
      
      .class_selector
        float: left
        width: 600px
      
      #id_selector
        background-color: #375
    END_SASS
  end

  let(:output_filename) { 'output.yml' }
  let(:output_file) { File.open(output_filename, 'w') }  

  before do
    File.write(input_filename, input_content)
  end

  after do
    input_file.close if !(!input_file || input_file.closed?)
    output_file.close if !(!output_file || output_file.closed?)
    File.delete(input_filename)
  end

  describe '#scan_sass' do
    let(:invoke) { scanner.scan_sass }

    it 'writes the result as a YAML to the output file' do
      expected_result = {
        '#id_selector'    => [1, 10],
        '.class_selector' => [6]
      }
      invoke
      expect(YAML.load_file(output_filename)).to eq expected_result
    end    
  end

end
