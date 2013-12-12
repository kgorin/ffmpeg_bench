require 'benchmark'
require 'fileutils'

class NoInput < StandardError; end;
class NoOutput < StandardError; end;

input = ARGV[0]
input2 = ARGV[1]
output = ARGV[2]

raise NoInput if input.nil? || input2.nil?
raise NoOutput if output.nil?

File.delete("done") if File.exist?("done")
File.delete("ffmpeg.log") if File.exist?("ffmpeg.log")


puts "\n\nthrs%-3s sys%-11s user%-10s total%-9s real%-10s" % ["", "", "", "", ""]

result = {}
(1..12).each do |thread_count|
  command = "ffmpeg -y -i #{input} -i #{input2} -vcodec libx264 -profile main -preset veryfast -acodec libmp3lame -r 25 -qmax 20 -pix_fmt yuv420p -map 0:0 -map 1 -ar 44100 -ac 2 -vf scale=1280:544 -threads #{thread_count} #{output} 2>>ffmpeg.log"

  # puts "\n\nRunning with #{thread_count} threads: #{command}"

  b = Benchmark.measure do
    `#{command}`
  end

  result[thread_count] = b
  puts "%-7s %-14s %-14s %-14s %-14s" % [thread_count, b.cstime.round(4), b.cutime.round(4), b.total.round(4), b.real.round(4)]
end

# puts "\n\nthrs%-3s sys%-11s user%-10s total%-9s real%-10s" % ["", "", "", "", ""]
# result.each do |thread_count, b|
#   puts "%-7s %-14s %-14s %-14s %-14s" % [thread_count, b.cstime.round(4), b.cutime.round(4), b.total.round(4), b.real.round(4)]
# end

f = File.new('done', 'w+')
f.close
