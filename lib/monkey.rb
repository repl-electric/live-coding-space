class SonicPi::Core::RingVector
  def take(n)
    SonicPi::Core::RingVector.new(self.to_a.take(n))
  end
  def shuffle
    SonicPi::Core::RingVector.new(self.to_a.shuffle)
  end
  def filter(&fun)
    SonicPi::Core::RingVector.new(self.to_a.filter(&fun))
  end
  def reject(&fun)
    SonicPi::Core::RingVector.new(self.to_a.reject(&fun))
  end
end
