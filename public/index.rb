#!/home/homepage/.rbenv/shims/ruby

require 'pathname'

root_path = Pathname.new(Dir.pwd)
template_file_path = root_path.join('../index.html')
images_dir_path = root_path.join('images')
words_file_path = root_path.join('../words.txt')

images = Dir.glob(images_dir_path.join('*.jpg'))
image = images.sample
image.gsub!(/#{root_path}/, '')

words = File.open(words_file_path).readlines.map &:chomp
word = words.sample

template = nil
File.open(template_file_path, 'r') do |f|
  template = f.read
end
template.gsub!(/<%= image %>/, image)
template.gsub!(/<%= word %>/, word)

puts "Content-Type: text/html\n\n"
# puts images.inspect
# puts image
puts template
