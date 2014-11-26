bar = 1/8.0

live_loop :metro do
  16.times{cue :sixteen;sleep bar;}
end

# | 1 2 3 4 | 5 6 (7) 8 | 9 (10) 11 12 | 13 14 15 16

with_fx :reverb do
live_loop :kickers do
  sync :sixteen
  sample :drum_heavy_kick, amp: 1.0
  3.times{sync :sixteen}
  
  sync :sixteen
  sample :elec_soft_kick
  3.times{sync :sixteen}

  sync :sixteen
#  sample :drum_bass_soft
  3.times{sync :sixteen}

  sync :sixteen
  sample :elec_soft_kick
  3.times{sync :sixteen}  
end
end

with_fx :reverb do
live_loop :synco do
  4.times{sync :sixteen}

  3.times {sync :sixteen}
  sample :bd_gas
  1.times {sync :sixteen} 
  
  2.times {sync :sixteen}
  sample :bd_gas
  2.times {sync :sixteen}

  4.times{sync :sixteen} 
end
end

with_fx :reverb do
live_loop :snares do
  sync :sixteen
  3.times{sync :sixteen}

  sample :elec_pop, amp: 0.1
  sync :sixteen
  sample :elec_snare
  3.times{sync :sixteen}

  sample :elec_pop, amp: 0.2
  sync :sixteen
  sample :elec_mid_snare, rate: 1
  3.times{sync :sixteen}

  sync :sixteen
  sample :elec_snare
  3.times{sync :sixteen}
end
end

with_fx :reverb do
live_loop :d3 do
  1.times {sync :sixteen}
  sample :elec_tick
  3.times {sync :sixteen}
end
end

set_volume! 2
