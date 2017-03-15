#!/home/homepage/.rbenv/shims/ruby

require 'pathname'
require 'cgi/session'

# path
root_path = Pathname.new(Dir.pwd)
template_file_path = root_path.join('../index.html')
images_dir_path = root_path.join('images')
words_file_path = root_path.join('../words.txt')

cgi = CGI.new
session = CGI::Session.new(cgi)

words = File.open(words_file_path).readlines.map &:chomp
used_words = session['words'].nil? ? [] : session['words']
used_words.uniq!
word = nil
unused_words = words - used_words
if unused_words.empty?
  word = words.sample
  session['words'] = [word]
else
  word = unused_words.sample
  session['words'] = used_words.push(word)
end

images = Dir.glob(images_dir_path.join('*.jpg'))
used_images = session['images'].nil? ? [] : session['images']
used_images.uniq!
image = nil
unused_images = images - used_images
if unused_images.empty?
  image = images.sample
  session['images'] = [image]
else
  image = unused_images.sample
  session['images'] = used_images.push(image)
end
image = image.gsub(/#{root_path}/, '')

puts cgi.header({charset: 'UTF-8'})

template = nil
File.open(template_file_path, 'r') do |f|
  template = f.read
end
template.gsub!(/<%= image %>/, image)
template.gsub!(/<%= word %>/, word)

# puts "Content-Type: text/html\n\n"
# puts images.inspect
# puts image
puts template
# puts session['images']
