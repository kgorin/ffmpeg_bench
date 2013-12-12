require 'fileutils'

Dir.glob('files/*_ffmpeg.log').each { |f| File.delete(f) }
Dir.glob('files/out_*').each { |f| File.delete(f) }
Dir.glob('files/in_*').each { |f| File.delete(f) }
Dir.glob('files/*_done').each { |f| File.delete(f) }
Dir.glob('files/multi_log.txt').each { |f| File.delete(f) }
