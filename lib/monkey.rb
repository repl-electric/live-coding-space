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

def sample_smash(sample_file, bits, *args, &block)
  if sample_file
    data = smash(sample_file, bits)
    opt = args[0]
    selection = data[:data].shuffle
    fx_selection = opt[:fx] || ring(:none,:none)
    opt.delete(:fx)
    at do
      selection.each do |d|
        opt[:start] = d[0]/data[:total]
        opt[:finish] = d[1]/data[:total]
        with_fx(fx_selection.tick(:fx), mix: 1.0) do
          sample(sample_file, *[opt])
        end
        yield block if block_given?
        sleep d[1]-d[0]
      end
    end
    selection
  end
end

module OneShotState
  def self.reset!
    @state = {}
  end
  def self.fired?(s)
    @state ||= {}
    @state[s] == true
  end
  def self.fire(s)
    @state ||= {}
    @state[s] = true
  end
end

GAIA_PAT  = Regexp.new(/gaiazone/i).freeze
SNARE_PAT = Regexp.new(/snare/i).freeze
KICK_PAT  = Regexp.new(/kick/i).freeze
VOCAL_PAT = Regexp.new(/vog_strw_sus_oh_f_01_rel/i).freeze

#VERTEX_MODE = ring("points", "tri_lines", "tri_lines")

def drifting(s,e,over, &block)
  drift_sleep = line(s,e,over).tick(:drifting)
  at do
    sleep drift_sleep
    block.()
  end
end

def one_smp(*args)
  s = args.first
  if !OneShotState.fired?(s)
    smp(*args)
    OneShotState.fire(s)
  end
end

def syn(*args)
  if args["note"] != "_"
    synth *args
  end
end

def smp(*args)
  sample_thing = args.first
  if sample_thing
    smp_name = if sample_thing.is_a?(Hash)
                 sample_file = sample_thing[:path]
                 if sample_thing[:onset] && sample_thing[:offset]
                   start = ratio_on(sample_thing) + (args.last[:start_offset] || 0)
                   fini = ratio_off(sample_thing) + (args.last[:finish_offset] || 0)
                 else
                   start = 0
                   fini = 1
                 end
                 options = {start: start, finish: fini}
                 options = if sample_thing.keys.length > 1
                             options.merge(args.last)
                           else
                             options
                           end
                 options.delete(:onset) #Corrupts if left
                 options.delete(:offset)
                 args=([sample_file] + [options])
                 sample *args
                 sample_file
               else
                 sample(*args)
                 sample_thing
               end

    if smp_name =~ GAIA_PAT
      shader [:iR, :iG, :iB].choose, rand*2
    elsif smp_name =~ SNARE_PAT
      #      shader :decay, :iVertexCount, 1
      shader :iCircle, [rand(100000),1000].max
      shader :iVertexCount, rand(100)
    elsif smp_name =~ VOCAL_PAT
      shader :iP, rand*2 #64.0 * rand(10)
      @mode = (["points", "lines", "tri", "line_loop", "line_strip"] - [@mode]).choose
    elsif smp_name =~ KICK_PAT
      shader :iVertexCount, [rand(1000), 400].max
      #      shader :iVertexCount, 100000
      shader :decay, :iBeat, [rand,2.5].max, 0.01
    end

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

def spread_with(start_value,end_value, on_value, off_value)
  (spread start_value,end_value).map{|s| s ? on_value : off_value}
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
