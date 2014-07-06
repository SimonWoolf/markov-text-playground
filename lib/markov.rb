class Markov

  def self.file_to_string(filename)
    # class method so stubbable before initialize
    File.open(filename, "r") do |file|
      file.read
    end
  end

  def initialize(textlist)
    @cache = textlist.each_with_object({}) do |text, textcache|
      textcache.merge!(generate_cache(text))
    end
  end

  def doubles_from_file(filename)
    self.class.file_to_string(filename).scrub
                                       .split
                                       .each_cons(2)
  end

  def doubles_from_text(string)
    string.scrub.split.each_cons(2)
  end

  def generate_cache(text)
    # cache is a hash with values an array of all words occuring
    # immediately after the key
    doubles_from_text(text).each_with_object({}) do |(first, second), cache|
      cache[first] ||= []
      cache[first] << second
    end
  end

  def successor_count(word)
    @cache[word].each_with_object({}) do |successor, counts|
      counts[successor] ||= 0
      counts[successor] += 1
    end
  end

  def popular_successors_to(word, n=10)
    return nil unless @cache.include? word
    successor_count(word).sort_by{|w, count| count}
                                .reverse
                                .first(n)
  end

  def random_successor_to(word)
    @cache[word].sample
  end

  def random_word
    @cache.keys.sample
  end

end
