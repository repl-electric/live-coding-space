beat = 1/2.0
snare2_s = :drum_snare_soft
beat = 1/2.0
shaker_s = "/Users/josephwilk/Dropbox/repl-electric/samples/pi/250531__oceanictrancer__shaker-hi-hat.wav"
clap_s = "/Users/josephwilk/Dropbox/repl-electric/samples/Analog\ Snares\ \&\ Claps/13\ \ EMT140\ \(3\).wav"
high_hat_s = "/Users/josephwilk/Workspace/music/samples/LOOPMASTERS\ EXCITE_PACK2014/ESSENTIAL_EDM_2/EDM2_SOUNDS_AND_FX/EDM2_Kit_1_HiHat_1.wav"
high_hat2_s = "/Users/josephwilk/Workspace/music/samples/LOOPMASTERS\ EXCITE_PACK2014/ESSENTIAL_EDM_2/EDM2_SOUNDS_AND_FX/EDM2_Kit_1_HiHat_2.wav"
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
def hollowed_synth(n)
  use_synth :hollow
  with_fx :pitch_shift, pitch_dis: 0.001, time_dis: 0.1, window_size: 1.5  do
    #with_fx :slicer, phase: 1/64.0 do
    play n, release: 8, amp: 2
    #end
  end
end

def degrees_seq(*pattern_and_roots)
  pattern_and_roots = pattern_and_roots.reduce([]){|accu, id| 
  if(!accu[-1].kind_of?(Symbol) && id.kind_of?(Integer))
    accu[0..-2] << "#{accu[-1]}#{id}"
  else
    accu << id
  end}
 patterns = pattern_and_roots.select{|a| (a.kind_of?(Fixnum) || a.kind_of?(String))} 
 roots   = pattern_and_roots.select{|a| a.kind_of? Symbol}
 notes = patterns.each_with_index.map do |pattern, idx|
  root = roots[idx]
  s = /[[:upper:]]/.match(root.to_s[0]) ? :major : :minor
  pattern.to_s.split("").map{|d| degree(d.to_i, root, s)}
 end.flat_map{|x| x}
 (ring *notes)
end

def chords_seq(pattern, root, s=nil)
  if !s
    s = /[[:upper:]]/.match(root.to_s[0]) ? :major : :minor
  end
  pattern.to_s.split("").map{|d| chord_degree(d.to_i, root, s)}
end

wood_s = "/Users/josephwilk/Dropbox/repl-electric/samples/Analog\ Snares\ \&\ Claps/17\ \ EMT140\ \(1\).wav"

r2=0
live_loop :ride do |r|
  with_fx :level, amp: 0.0 do
    sync :half_beat
    sample (ring high_hat_s, high_hat_s,high_hat_s, high_hat2_s)[r2], amp: 0.5, start: 0.01, finish: rand(0.9..1.0)
    #sleep beat
    2.times do
      start = case r%6
      when 0
        0.3
      else
        0.45
      end
      with_fx :reverb do
        sample shaker_s,amp: 0.4, start: start
      end
      sleep beat/2
      sample shaker_s, amp: 0.2, start: 0.3
      r+=1
    end
    r2+=1
  end
end
live_loop :clock do
  cue :start; cue :beat; cue :half_beat
  sleep beat/2
  cue :half_beat
  sleep beat/2
  cue :half_beat; cue :beat
  sleep beat/2
  cue :half_beat
  sleep beat/2
end

live :drums, amp: 0.2 do |n|
  with_fx(:lpf, cutoff: 40){sample :drum_heavy_kick}
  cue :start
  cue :half_hit
  sleep beat/2
  cue :half_hit
  sleep beat/2
  cue :half_hit

 with_fx :level, amp: 0.2 do
    case n%6
    when 0
      with_fx(:slicer, phase: 1.0){with_fx(:echo, phase: beat/4, decay: 0.09){with_fx(:bitcrusher, bits: 6){
      sample snare2_s, amp: 0.8, finish: 1.0}}}
    when 3
      with_fx(:bitcrusher, bits: 8){
      sample snare2_s, amp: 1.15, start: 0.15,  finish: 0.8}
    when 5
      with_fx(:bitcrusher, bits: 7){
      sample snare2_s, amp: 1.1, start: 0.15, finish: 0.9}
    else
      sample snare2_s, start: 0.20, amp: 1.1, rate: 1.0, finish: 0.45
    end
end
  with_fx(:lpf, cutoff: 20){sample :drum_heavy_kick}
  sleep beat/4
  cue :quarter_hit
  sleep beat/4
  cue :quarter_hit
  cue :half_hit
  sleep beat/2
  n+=1
end

live :pulse3, amp: 0.4 do |p_inc|
 sync :half_hit, :quarter_hit
 with_synth :hollow do
   #sample wood_s, amp: 0.4, start: 0.1
   play degrees_seq(:Cs3, 1113111311131114)[p_inc], attack: 0.01, release: beat/2, amp: 4.00
   with_synth :growl do
   play degrees_seq(:Cs5, 1113111311131114)[p_inc], attack: 0.001, release: beat/2, amp: 2.00
   end
   #sleep (ring beat/2, beat/2, beat/4, beat/4)[p_inc]
   sleep beat/4
 end
 p_inc+=1
end

live :pulse4, amp: 1.0 do |p_inc|
 sync :half_hit #,:quarter_hit
 with_synth :hollow do
   #sample wood_s, amp: 0.4, start: 0.1
   case p_inc % 16
   when 0
    play degrees_seq(:Cs4, 1), attack: 0.01, release: beat/4, amp: 1.00
    sleep beat/2
    play degrees_seq(:Cs4, 1), attack: 0.01, release: 0.2, amp: 1.00
   else
    play degrees_seq(:Cs3, 1), attack: 0.01, release: 0.2, amp: 1.00
   end
 end
 p_inc+=1
end

live :highlights2, amp: 0.3 do |h_inc|
  with_synth :dark_ambience do 
  sync :half_hit
  play degrees_seq(:Cs3, 101010101010101, :Cs4, 0000)[h_inc], release: beat*4+(0.1*rand)
  end
  sleep beat
  h_inc+=1
end

live :highlights3, amp: 0.0 do |h_inc|
  sync :half_hit
  with_synth :mod_fm do 
    play degrees_seq(:Cs2, 1314)[h_inc], release: beat*8+(0.1*rand)
  end
  sleep beat*4
  h_inc+=1
end

live :highlights, amp: 0.2 do |h_inc|
  sync :half_hit
  play degrees_seq(:Cs3, 333322221111106000, :Cs3, 6655544444)[h_inc]
  sleep beat
  h_inc+=1
end

live :deep, amp: 0.0 do |d_inc|
  with_fx :reverb do |r_fx|
  3.times{sync :start
   control r_fx, room: rand, mix: rand 
  }
 # with_fx :lpf, cutoff: 130 do
  with_synth :tri do
     play (ring *chords_seq(1, :Cs2))[d_inc], release: beat*6, attack: beat/2
  end
#end
  end
  d_inc+=1
end

live :holloweded, amp: 0.2 do |z_inc|
  hollowed_synth (ring *degrees_seq(1, :Cs3, :major))[z_inc]
  sleep beat
  z_inc+=1
end

set_volume! 2.0
