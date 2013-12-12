require 'benchmark'
require 'fileutils'

class NoInput < StandardError; end;
class NoOutput < StandardError; end;

input = ARGV[0]
output = ARGV[1]
log = ARGV[2]

raise NoInput if input.nil?
raise NoOutput if output.nil?

command = "ffmpeg -y -i #{input} -vcodec libx264 -profile main -preset veryfast -acodec libmp3lame \
 -r 25 -qmax 20 -pix_fmt yuv420p -ar 44100 -ac 2 -vf scale=1280:544 #{output} 2>>files/#{Process.pid}_ffmpeg.log"

b = Benchmark.measure do
  `#{command}`
end

log_file = File.open(log, "a")
log_file.write("\n%-14s %-14s %-14s %-14s" % [b.cstime.round(4), b.cutime.round(4), b.total.round(4), b.real.round(4)])
log_file.close

f = File.new("#{output}_done", 'w+')
f.close
