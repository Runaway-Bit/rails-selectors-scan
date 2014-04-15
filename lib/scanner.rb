require 'yaml'

class Scanner

  MULTILINE_COMMENT_END = /\*\//

  attr_reader :result

  def initialize(input_file, output_file)
    @result = Hash.new([])
    @input_file = input_file
    @output_file = output_file
  end

  def scan_sass
    commented = false
    @input_file.each.with_index do |line, i|
      line.strip!
       
      unless commented
        comment_starts = /(.*)\/\*(.*)/.match(line)
        unless comment_starts.nil?
          before_comment, after_comment = comment_starts.captures
          line = before_comment.strip
          
          # Flag is on for next iteration if the comment does not end here
          commented = MULTILINE_COMMENT_END.match(after_comment).nil?
        end
        
        unless line.empty? || !(/(:\s|\A\/\/|\A@import)/ =~ line).nil?
          selectors, *after_comment = line.split('//')
          selectors = selectors.split(',')
          selectors.each { |selector|  result[selector.strip] += [i + 1] }
        end
      end

      commented &&= MULTILINE_COMMENT_END.match(line).nil?
    end

    @output_file.write(result.to_yaml)
  end

  def scan_coffee
    @input_file.each.with_index do |line, i|
      line.strip!

      functions = ['\$','.children','.closest','.find','.next',\
        '.nextAll','.nextUntil','.offsetParent','.parent','.parents',\
        '.parentsUntil','.prev','.prevAll','.prevUntil','.siblings']

      matches = nil
      functions.each do |function|
        selectors = find_selectors(function, line)
        selectors.each { |selector|  result[selector.strip] += [i + 1] }        
      end
    end

    @output_file.write(result.to_yaml)
  end

  private
    def find_selectors(function, string)
      matches = /#{function}\(\s*['"]([^)]+)['"]\s*\)/.match(string)        
      # http://rubular.com/r/aJ7a81kNaR
      
      unless matches.nil?
        selectors = matches.captures.first.split(',')
        selectors += find_selectors(function, matches.post_match)
      end
      selectors || []
    end

end

if __FILE__ == $PROGRAM_NAME
  directory, output_filename = ARGV

  puts "###  SASS FILES  ###"
  puts Dir["#{directory}/**/*.sass"]
  puts "### COFFEE FILES ###"
  puts Dir["#{directory}/**/*.coffee"]
  File.delete(output_filename) unless !File.exist?(output_filename)

  Dir["#{directory}/**/*.sass"].each do |input_filename|
      begin
        input_file = File.open(input_filename, 'r')
        output_file = File.open(output_filename, 'a')
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

  Dir["#{directory}/**/*.coffee"].each do |input_filename|
      begin
        input_file = File.open(input_filename, 'r')
        output_file = File.open(output_filename, 'a')
        scanner = Scanner.new(input_file, output_file)
        scanner.scan_coffee
      rescue StandardError => e
        raise e
      ensure
        [input_file, output_file].each do |file|
          file.close unless file.nil?
        end
      end
  end
 
end
