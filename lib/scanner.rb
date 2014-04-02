class Scanner
    
  attr_reader :result
  
  def initialize(file)
    @result = Hash.new
    @file = file
  end
    
  def scan_sass
    @file.each_with_index do |line, i|
      result[line.chomp] = i + 1
    end
  end

end
