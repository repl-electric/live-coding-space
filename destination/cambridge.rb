_ = nil
bar = 1.0
use_bpm 60 
define :perc_s do |name,*args|
  s = Dir["/Users/josephwilk/Workspace/music/samples/AmbientElectronica_Main_SP/One\ Shots/Perc/MicroPerc_*_SP.wav"]
  s.sort!
  sample (if name.is_a? Integer
    s[name]
  else
  s.select{|s| s =~ /#{name}/}[0]
  end), *args
end
define :ambi_s do |s, *args|
  sample "/Users/josephwilk/Workspace/music/samples/AmbientElectronica_Main_SP/#{s}",*args
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
    ambi_s "One Shots/Kick/SubKick_01_SP.wav", amp: 3.0+rrand(0.0,0.2)
  when 4
    ambi_s "One Shots/Forest/Impact_05_SP.wav", amp: 0.2
  end

  #sample "/Users/josephwilk/Workspace/music/samples/AmbientElectronica_Main_SP/Bass/135_C_SwellBass_01_SP.wav",  rate: pitch_ratio(note(:Cs3) - note(:C3)), amp: 0.1
  #bowed_s "F#", rate: 0.5, amp: 0.2
m_idx+=1
end

live_loop :foo do
  #sample "/Users/josephwilk/Dropbox/repl-electric/samples/Guitar\ Tails/92_Eb_Plucked_01_SP.wav", rate: pitch_ratio(note(:Fs2) - note(:Eb3))
  density(@polyrhythm.sort.first) { play :FS2; sleep bar }
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
4.times{sync :foo}
with_fx (ring :none, :echo).tick(:a), phase: bar/4.0, decay: bar*8 do
with_synth :hollow do
  play degree((knit 3,1,4,1,5,1).tick(:r1), :FS4, :major), attack: 0.5, amp: 0.5
end
end
end

live_loop :high do
 2.times{sync :start}
 sample (knit "/Users/josephwilk/Workspace/music/samples/AmbientElectronica_Main_SP/One\ Shots/Perc/MicroPerc_06_SP.wav",3,
              "/Users/josephwilk/Workspace/music/samples/AmbientElectronica_Main_SP/One\ Shots/Perc/MicroPerc_07_SP.wav",1).tick(:s)

end


#33333333 44      55
#11111111     111111111      11
