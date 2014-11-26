 bar = 1/8.0

live_loop :metro do
  cue :sixteen; cue :middle; sleep bar/2; cue :middle; sleep bar/2;
end

#|1 2 3 4|5 6 7 8|9 10 11 12|13 14 15 16|

live_loop :ride do
  2.times{sync :sixteen}
  sample :drum_cymbal_closed, rate: 1, amp: rrand(1.1, 1.2)
  2.times{sync :sixteen}
  sample :drum_cymbal_closed, rate: 1, amp: rrand(1.0, 1.1)

  6.times{
    sync :sixteen
    sample :drum_cymbal_closed, start: 0.2, amp: rrand(0.9,1.0) 
    sync :sixteen
  }
end

#|1 2 3 4|5 6 7 8|9 10 11 12|13 14 15 16|

with_fx :level, amp: 1 do
live_loop :kick do
  double = (dice(6) > 4)
  s = [:elec_snare, :elec_hollow_kick].choose
  
  #BAR1
  sync :sixteen
#  with_fx :echo, phase: bar*[9].choose do
  with_fx :distortion, distort: 0.6 do
    sample :drum_heavy_kick, start: 0.0, amp: 1.0
    end
 # end
  
  4.times{sync :sixteen}
  sample :elec_soft_kick
  
  2.times{sync :sixteen}
  sample :elec_soft_kick
  2.times{sync :sixteen}
 
  sample :drum_snare_soft, amp: 3
  1.times{sync :sixteen}
  sample :drum_snare_soft, amp: 3 if dice(6) >= 5
  1.times{sync :sixteen}
  
  sample :elec_soft_kick
  2.times{sync :sixteen}

  sample :elec_soft_kick
  3.times{sync :sixteen}
end
end

with_fx :level, amp: 1 do
with_fx :lpf, cutoff: 100 do
live_loop :striate do
  #BAR1
  s = :elec_hollow_kick
  sync :sixteen; 
  sample s, rate: 0.9
  sync :sixteen; 
  with_fx :echo, phase: bar/2 do
  2.times { sync :sixteen; sample s, rate: 1.01; }
  end
  
  #BAR2
  4.times{sync :sixteen}

  #BAR3
  sync :sixteen
  with_fx :distortion, distort: 0.8 do
    sample s, amp: 0.8, rate: 0.9
  end

  2.times{sync :sixteen} 
  sample :drum_heavy_kick, rate: -1, amp: 4 if dice(6)>3
  1.times {sync :sixteen}
  
  #BAR4
  sync :sixteen
  with_fx :distortion, distort: 0.5 do
    sample s, amp: 0.8, rate: 0.8
  end
  3.times{sync :sixteen}
end
end
end

live_loop :bass do
with_fx :distortion, distort: 0.1 do
with_fx :lpf, cutoff: 80 do
  sync :sixteen
  use_synth :saw
  play_chord chord(:A1, :major), release: 1.0, decay: 0.7, sustain: 0.7
  15.times{sync :sixteen}
  
  end
  end
end