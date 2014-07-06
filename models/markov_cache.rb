class MarkovCache
  # Persistant cache of the current markov object.
  # NB we assume this app will only ever have
  # one user - need to move to session-based cache if that
  # ever changes

  @@markov = nil
  @@texts = TextStore.new

  def self.markov=(markov)
    @@markov = markov
  end

  def self.texts=(texts)
    @@texts = texts
  end

  def self.markov
    @@markov
  end

  def self.texts
    @@texts
  end
end
