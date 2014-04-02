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
      line = line.chomp

      if !!(/\A[\.#][a-zA-Z_-]+/ =~ line)
        result[line] += [i + 1]
      end
    end

    @output_file.write(result.to_yaml)
  end

end

