bar = 1/2.0
quart = 2*bar

set_volume! 1.0
p_s = "/Users/josephwilk/Dropbox/repl-electric/samples/pi/piano_a.wav"
p1_s = "/Users/josephwilk/Dropbox/repl-electric/samples/pi/148533__neatonk__piano-med-a2.wav"
v_s = "/Users/josephwilk/.overtone/orchestra/violin/violin_A3_1_piano_arco-normal.wav"
radio_s = "/Users/josephwilk/Dropbox/repl-electric/samples/pi/32266__paracelsus__radio.wav"

live_loop :metro do
  cue :start; cue :quart;  cue :bar
  sleep bar
  cue :bar
  sleep bar
  cue :quart; cue :bar
  sleep bar
  cue :bar
  sleep bar
end

live_loop :drum do
  sync :quart
  with_fx :lpf do
    sample :elec_triangle, amp: 0.1
  end
end

live_loop :vio do
  3.times{sync :start}
  with_fx :reverb, room: 1, mix: 1 do
    sample v_s, amp: 20
  end
end

live_loop :radio do
  sample radio_s, amp: 8, rate: 0.1
  sleep sample_duration(radio_s)
end

live_loop :piano do
  sync :quart
  with_fx :reverb do
    sample p_s, amp: 2
  end
end

live_loop :dark do
  use_synth :beep
  sync :start
  with_fx(:reverb, room: 1, mix: 1){sample p1_s, amp: 4, rate: 0.99}
  sample :ambi_lunar_land, rate: 0.25, amp: 0.9
  play degree(:i, :A1, :minor), attack: 0.1, release: bar*4, decay: bar*4, amp: 8
  use_synth :noise
  play degree(:i, :A1, :minor), release: bar*4, amp: 0.1
  15.times{ sync :start }
end

define :beeper do |note, direction|
  use_synth :supersaw #:mod_saw
  use_synth_defaults sustain_level: 0.1, res: 1, env_curve: 7 ,sustain: 0.2, attack: 0.01, decay: 0.15, amp: 1.0, release: 0.01, attack_level: 0.8 
  #with_fx :lpf, cutoff: 100 do
  with_fx :echo, phase: bar, max_phase: 1 do
  
  play note, attack: 0.001,  pan: 0.8*direction
  sleep bar/2
  play note, attack: 0.001,  pan: 0.7*direction
  sleep bar/2
  play note, attack: 0.001,  pan: 0.6*direction
  sleep bar/2
  play note, attack: 0.009,  pan: 0.5*direction
  sleep bar/2 
  
  play note, attack: 0.001, pan: 0.4*direction
  sleep bar/2
  play note, attack: 0.005, pan: 0.3*direction
  sleep bar/2
  play note, attack: 0.007,  pan: 0.2*direction
  sleep bar/2
  play note, attack: 0.009,  amp: 1.5, pan: 0.1*direction
  sleep bar/2
  
  sleep bar
  #end
  end
end

live_loop :beep do
 sync :bar
 direction = rand_i(-1..1)
 beeper degree(1, :A3, :minor), direction
end

live_loop :deep do
  use_synth :fm
  sync :start
  #with_fx :slicer, phase: bar*4 do
  #play degree(1, :A1, :minor), release: bar*4, decay: bar*4, amp: 0.2
  #end
end