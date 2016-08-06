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
  def select(&fun)
    SonicPi::Core::RingVector.new(self.to_a.select(&fun))
  end
end
module Shaderview
  def self.voc
    shader :shader, "voc.glsl", "bits.vert", "points", 10000
    shader :iStarMotion, 0.8
    shader :iSpaceLight, 0.4
    shader :iStarLight, 0.8
    shader [:iR, :iB, :iG], 3.0
    shader :iForm, 1.0
    shader :iMotion, 0.1
    shader :iSize,10.1
    shader :iDistort, 100.0
  end
  def self.wave
    shader :shader, "wave.glsl", "bits.vert", "points", 10000
    shader [:iR, :iB, :iG], 3.0
    shader :iForm, 0.01
    shader :iDir, 1.0
    shader :iMotion, 0.002
    shader :iWave, 0.01
    shader :iSize, 100.9
    shader :iPointSize, 0.2
    shader :iDistort, 0.005
    shader :iWave, 0.0
  end
end
