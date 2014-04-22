def file_to_string(filename)
  File.open(filename, "r") do |file|
    file.read
  end
end

def doubles(filename)
  file_to_string(filename).scrub
                          .split
                          .each_cons(2)
end

def generate_cache(filename)
  # cache is a hash with values an array of all words occuring 
  # immediately after the key
  doubles(filename).each_with_object({}) do |(first, second), cache|
    cache[first] ||= []
    cache[first] << second
  end
end

def successor_count(word, cache)
  cache[word].each_with_object({}) do |successor, counts|
    counts[successor] ||= 1
    counts[successor] += 1
  end
end

def popular_successors_to(word, cache, n=10)
  successor_count(word, cache).sort_by{|w, count| count}
                              .reverse
                              .first(n)
end

cache = generate_cache("inputs/foundation.txt")

require 'awesome_print'
ap popular_successors_to("the", cache)
