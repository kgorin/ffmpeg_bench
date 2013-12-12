require 'fileutils'
require 'pathname'
require 'pry'

class NoInput < StandardError; end;
class NoOutput < StandardError; end;

input = ARGV[0]
inst_count = (ARGV[1] || 1).to_i

raise NoInput if input.nil?

Dir.glob('files/*_ffmpeg.log').each { |f| File.delete(f) }
Dir.glob('files/out_*').each { |f| File.delete(f) }
Dir.glob('files/*_done').each { |f| File.delete(f) }

log_path = "files/multi_log.txt"
log_file = File.open(log_path, "a")
log_file.write("\n\nsys%-11s user%-10s total%-9s real%-10s" % ["", "", "", "", ""])
log_file.close

puts "copying input files"
inst_count.times.each do |count|
  puts count
  path = Pathname.new(input)
  input_copy = File.join(path.dirname, "in_#{count}#{path.extname}")
  FileUtils.cp(input, input_copy)
end

puts "spawning instances"
inst_count.times.each do |count|
  puts count
  path = Pathname.new(input)
  input_copy = File.join(path.dirname, "in_#{count}#{path.extname}")
  output_copy = File.join(path.dirname, "out_#{count}#{path.extname}")

  Process.spawn "ruby multi_bench.rb #{input_copy} #{output_copy} #{log_path} 2>>ffmpeg.log"
end
