require 'rspec'
require 'wrong/adapters/rspec'

require_relative '../lib/markov'

describe Markov do

  before :each do
    Markov.stub(:file_to_string){"the quick brown fox the quick red dog the two"}
    @markov = Markov.new([nil])
  end
  
  specify 'cache generator' do
    assert { @markov.instance_variable_get(:@cache) == {"the"=>["quick", "quick", "two"],
                                                        "quick"=>["brown", "red"],
                                                        "brown"=>["fox"],
                                                        "fox"=>["the"],
                                                        "red"=>["dog"],
                                                        "dog"=>["the"]} }
  end

  specify 'successor_count' do
    assert { @markov.successor_count("the") == {"quick" => 2, "two" => 1} }
  end

end
