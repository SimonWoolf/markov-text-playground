def file_to_string(filename)
  File.open(filename, "r") do |file|
    file.read
  end
end

def doubles
  file_to_string("inputs/foundation.txt").scrub.split.each_cons(2)
end

puts doubles.first(20).inspect
