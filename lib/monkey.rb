#🐒

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

def note_to_semi(n1,n2)
  notes = ring(:F, :Fs, :G, :Gs, :A, :As, :B, :C, :Cs, :D, :Ds, :E)
  start_hit = notes.index(note_info(n1).pitch_class)
  goal_hit = notes.index(note_info(n2).pitch_class)
  octave_diff = note_info(n2).octave - note_info(n1).octave
  if octave_diff < 0
    diff = (start_hit - goal_hit) + octave_diff*12
  else
    diff = (goal_hit - start_hit) + octave_diff*12
  end
end

def smash(s,bits)
  total_time = sample_duration(s)
  positions = bits.reduce([0]){|acc,bit| acc << acc[-1]+(total_time/bit)}
  load_sample s
  s_idx=0
  data = positions.reduce([]) do |acc,p|
    s_pos = positions[s_idx]
    e_pos = (positions[s_idx+1] || total_time)
    s_idx+=1
    acc << [s_pos, e_pos]
  end
  {sample: s, data: data, total: total_time}
end
def smash_loop(s, *args)
  opt = args[0]
  s[:data].shuffle.each do |d|
    opt[:start] = d[0]/s[:total]
    opt[:finish] = d[1]/s[:total]
    sample(s[:sample], *[opt])
    sleep d[1]-d[0]
  end
end


def smp(*args)
  sample_thing = args.first
  smp_name = if sample_thing.is_a?(Hash)
    sample_file = sample_thing[:path]
    start = ratio_on(sample_thing)
    fini = ratio_off(sample_thing)
    options = {start: start, finish: fini}
    options = if args.length > 1
      options.merge(args.last)
    else
      options
    end
    sample sample_file, *[options]
    sample_file
  else
    sample(*args)
    sample_thing
  end
  if smp_name =~ /kick/
    shader :decay, :iBeat, 1.0, 0.001 
  end
end

def ratio_on(smp)
  if smp
    dur = sample_duration(smp[:path])
    smp[:onset]/dur+0.0
  end
end
def ratio_off(smp)
if smp
  dur = sample_duration(smp[:path])
  smp[:offset]/dur+0.0
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
    shader :shader, "wave.glsl", "bits.vert", "points", 5000 #TOOOOOO MANY DOTS
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
