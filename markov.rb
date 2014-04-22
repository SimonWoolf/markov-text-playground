def file_to_string(filename)
  File.open(filename, "r") do |file|
    file.read
  end
end

def doubles(filename)
  file_to_string(filename).scrub.split.each_cons(2)
end

def generate_cache(filename)
  doubles(filename).each_with_object({}) do |(first, second), cache|
    cache[first] ||= []
    cache[first] << second
  end
end

require 'awesome_print'
ap generate_cache("inputs/foundation.txt")['outer']


