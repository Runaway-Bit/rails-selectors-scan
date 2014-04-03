require 'yaml'

class Scanner

  attr_reader :result

  def initialize(input_file, output_file)
    @result = Hash.new([])
    @input_file = input_file
    @output_file = output_file
  end

  def scan_sass
    @input_file.each.with_index do |line, i|
      line.strip!

      if !!(/\A[a-zA-Z&]*[\.#][a-zA-Z_-]+/ =~ line)
        result[line] += [i + 1]
      end
    end

    @output_file.write(result.to_yaml)
  end

end

if __FILE__ == $PROGRAM_NAME
  input_filename, output_filename = ARGV
  
  begin
    input_file = File.open(input_filename, 'r')
    output_file = File.open(output_filename, 'w')
    scanner = Scanner.new(input_file, output_file)
    scanner.scan_sass
  rescue StandardError => e
    raise e
  ensure
    [input_file, output_file].each do |file|
      file.close unless file.nil?
    end
  end
  
end
