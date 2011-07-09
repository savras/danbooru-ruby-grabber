# coding: utf-8

# Author: Ivan "Xeron" Larionov
# E-mail: xeron.oskom@gmail.com
# Homepage: http://xeron.13f.ru
# Version: 1.0

require './lib/booru'
require './lib/danbooru'
require './lib/konachan'
require './lib/e621'

options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: danbooru.rb [options] \"tags\""
  opts.on( '-k', '--konachan', 'Download from konachan.com instead of danbooru.donmai.us' ) do
    options[:kona] = true
  end
  opts.on( '-e', '--e621', 'Download from e621.net instead of danbooru.donmai.us' ) do
    options[:e621] = true
  end
  opts.on( '-w', '--wget', 'Use wget for download' ) do
    options[:wget] = true
  end
  opts.on( '-c', '--curl', 'Use curl for download' ) do
    options[:curl] = true
  end
  opts.on( '-s', '--storage DIR', 'Storage mode (all images in one dir and symlinks in tagged dirs)' ) do |d|
    options[:storage] = d
  end
  opts.on( '-u', '--user USERNAME', 'Username' ) do |u|
    options[:user] = u
  end
  opts.on( '-p', '--password PASSWORD', 'Password' ) do |p|
    if options[:kona]
      password_string = "So-I-Heard-You-Like-Mupkids-?"
    else
      password_string = "choujin-steiner"
    end
    options[:password] = Digest::SHA1.hexdigest("#{password_string}--#{p}--")
    options[:password] = Digest::SHA1.hexdigest(p) if options[:e621]
  end
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end

begin
  optparse.parse!
rescue => ex
  puts ex
end

if ARGV.length == 0 || ARGV[0].empty?
  puts optparse.help
else
  puts "tags are #{ARGV[0]}"
  if options[:kona]
    d = Konachan.new(ARGV[0], options)
  elsif options[:e621]
    d = E621.new(ARGV[0], options)
  else
    d = Danbooru.new(ARGV[0], options)
  end
  d.download_all
end
