# ____ ____ _  _ ___  ____ _ ___  ____ ____ 
# |    |__| |\/| |__] |__/ | |  \ | __ |___ 
# |___ |  | |  | |__] |  \ | |__/ |__] |___                                           
_ = nil
bar = 1.0
use_bpm 60 
def chord_seq(*args)
  args.each_slice(2).reduce([]){|acc, notes| acc += chord(notes[0],notes[1])}
end
module Ambi
 def self.[](a)
  samples = Dir["/Users/josephwilk/Workspace/music/samples/AmbientElectronica_Main_SP/**/*.wav"]
  samples.select{|s| s=~ /#{a}/}[0]
 end
end
module Chill
 def self.[](a)
  samples = Dir["/Users/josephwilk/Workspace/music/samples/Sample\ Magic\ -\ Ambient\ and\ Chill\ -\ Wav/**/*.wav"]
  samples.select{|s| s=~ /#{a}/}[0]
 end
end
define :deg_seq do |*pattern_and_roots|
  pattern_and_roots = pattern_and_roots.reduce([]){|accu, id|
    if(/^[\d_]+$/ =~ accu[-1] && /^[\d_]+$/ =~ id)
      accu[0..-2] << "#{accu[-1]}#{id}"
    else
      accu << id
  end}
  patterns = pattern_and_roots.select{|a| /^[\d_]+$/ =~ a.to_s }
  roots   = pattern_and_roots.select{|a| /^[\d_]+$/ !~ a.to_s}
  notes = patterns.each_with_index.map do |pattern, idx|
    root = roots[idx]
    if(root[0] == ":")
      root = root[1..-1]
    end
    s = /[[:upper:]]/.match(root.to_s[0]) ? :major : :minor
    if(s == :minor)
      s = if    root.to_s[1] == "h"
        :harmonic_minor
      elsif root.to_s[1] == "m"
        :melodic_minor
      else :minor
      end
    end
    root = root[0] + root[2..-1] if root.length > 2
    pattern.to_s.split("").map{|d| d == "_" ? nil : degree(d.to_i, root, s)}
  end.flat_map{|x| x}
  (ring *notes)
end
define :bowed_s do |name, *args|
  s = Dir["/Users/josephwilk/Dropbox/repl-electric/samples/Bowed\ Notes/*_BowedGuitarNote_01_SP.wav"]
  s.sort!
  sample (if name.is_a? Integer
    s[name]
  else
  s.select{|s| s =~ /#{name}/}[0]
  end), *args
end
def live(name, opts={}, &block)
  idx = 0
  amp = if(opts[:amp])
    opts[:amp]
  else
    1
  end
  x = lambda{|idx|
    with_fx :level, amp: amp do
      block.(idx)
  end}
  live_loop name do |idx|
    x.(idx)
  end
end

@polyrhythm = [2,3]

live_loop :bass do |m_idx|
  sync :foo
 case (m_idx%8)
  when 0
    sample Ambi["SubKick_01"], amp: 3.0+rrand(0.0,0.2), rate: rrand(0.9,1.0)
  when 4
    sample Ambi["Impact_0#{(stretch (1..5).to_a, 8).tick(:b)}"], amp: 0.2
  end
  m_idx+=1
end

live_loop :beats do
  sync :foo
  #sample Ambi["B_BrokenCres_01_SP"]
  sample Ambi["Cracklin_01"], rate: 0.95, amp: 0.2
  sleep sample_duration(Ambi["92_DottedThud_01_SP.wav"])
end

live_loop :texture do
sync :foo
with_fx :bitcrusher do
sample Chill["am_pad80_warmth_B"], rate: pitch_ratio(note(:B2) - note((ring :FS2, :B2).tick(:d))),
       amp: 0.01
end
sleep sample_duration Chill["am_pad80_warmth_B.wav"], rate: pitch_ratio(note(:B2) - note(:FS2))
end

live_loop :foo do
  density(@polyrhythm.sort.first) { play :FS3; sleep bar }
end

live_loop :bar, autocue: false do
  sync :foo
  density(@polyrhythm.sort.last) do
  with_fx (knit :none,7, :echo, 1).tick(:r2), mix: 0.8, phase: bar/2.0  do
    n = degree((knit 3,8,4,8,5,2).tick(:r1), :FS3, :major)
    play n, pan: (Math.sin(vt*13)/1.5)
    sleep bar 
    if n == degree(5, :FS3, :major)
      cue :start  
    end
end
end
end

live_loop :bassline do |idx|
  #play (knit "Fs3",1).tick(:a), amp: 1.5, release: 2*bar, attack: 0.01
  2.times{sync :foo}
  with_synth :fm do
    play (knit "Cs2",3, "FS2" ,1, "B2", 2).tick(:a), amp: 2.5, release: 2*bar, attack: 0.01
  end
#play degree((knit 5,4,6,4,7,1).tick(:r1), :FS3, :major), amp: 1.0, release: 2*bar, attack: 0.01 if idx % 4 ==0
idx+=1
end

live_loop :highlight do |idx|
n = chord_seq(*%w{Cs4 7  Fs4 M  B3 M7})
with_fx (ring :none, :echo).tick(:a), phase: bar/4.0, decay: (knit bar*8, 3, bar*6,1).tick(:q) do
with_synth :hollow do
2.times{sync :foo}
  play n.tick(:f),  attack: 0.5, amp: 0.7
end
1.times{sync :foo}
  play n.tick(:f), attack: 0.01, amp: 0.4, release: ring(2.0,0.5).tick(:r3)
1.times{sync :foo}
end
end

live_loop :high do
 2.times{sync :start}
 sample (knit Ambi["MicroPerc_06"],3,
              Ambi["MicroPerc_07"],1).tick(:s)

end
