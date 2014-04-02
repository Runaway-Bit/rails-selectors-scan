class Scanner
    
  attr_reader :result
  
  def initialize(file)
    @result = Hash.new([])
    @file = file
  end
    
  def scan_sass
    @file.each.with_index do |line, i|
      line = line.chomp

      if !!(/\A[\.#][a-zA-Z_-]+/ =~ line)
        result[line] += [i + 1]
      end
    end    
  end

end
