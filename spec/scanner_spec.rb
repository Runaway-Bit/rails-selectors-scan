require 'scanner'

describe Scanner do
  subject(:scanner) { Scanner.new }
  
  it 'has a result which is a Hash' do
    expect(scanner.result).to be_a Hash
  end
  
  describe '#scan_sass' do
    let(:filename) { 'test_file.sass' }
    let(:invoke) { scanner.scan_sass(filename) }
    
    %w[#id_selector .class_selector].each do |selector|
      context "when the sass file contains '#{selector}'" do
        before do
          File.write(filename, selector)
        end
        
        after do
          File.delete(filename)
        end
        
        it 'adds a new selector to the result' do
          expect { invoke }.to change { scanner.result.size }.by(1)
        end
        
        specify "the result has a selector with key = '#{selector}'" do
          invoke
          expect(scanner.result[selector]).to_not be_nil
        end
      end
    end # selectors array .each
  end

end
