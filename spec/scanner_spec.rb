require_relative 'spec_helper'

describe Scanner, fakefs: true do
  
  selectors = %w[#id_selector .class_selector]
  
  subject(:scanner) { Scanner.new(file) }
  
  let(:file) { File.open(filename, 'r') }
  let(:filename) { 'test_file.sass' }
  
  let(:file_content) do
    selectors.inject('') do |content, selector|
      content += "#{selector}\n"
    end
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
    
    selectors.each do |selector|
      context "when the sass file contains '#{selector}'" do
        specify "the result has a selector with key = '#{selector}'" do
          invoke
          expect(scanner.result[selector]).to_not be_nil
        end
      end
    end # selectors array .each
  end

end
