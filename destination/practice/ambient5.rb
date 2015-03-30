["piano"].each{|f| require "/Users/josephwilk/Workspace/repl-electric/sonic-pi/lib/#{f}"}
bar = 1/2.0
quart = 2*bar
set_volume! 1.0

pa_s = "/Users/josephwilk/Dropbox/repl-electric/samples/pi/piano_a.wav"
p_c3_s = "/Users/josephwilk/Dropbox/repl-electric/samples/pi/148600__neatonk__piano-med-c3.wav"
p_a2_s = "/Users/josephwilk/Dropbox/repl-electric/samples/pi/148533__neatonk__piano-med-a2.wav"
p_c4_s = "/Users/josephwilk/Dropbox/repl-electric/samples/pi/148603__neatonk__piano-med-c4.wav"
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
live_loop :highlights do |high_n|
with_fx :level, amp: 0.4 do
 sync :high
 use_synth :sine
 play (ring degree(1, :A4, :major), degree(1, :A3, :major))[high_n]
 high_n += 1
end
end
live_loop :drum do
with_fx :level, amp: 0.2 do
  sync :quart
  with_fx :lpf do
    sample :elec_triangle, amp: 0.2
  end
end
end

vio_pan = -1
live_loop :vio do |vio_idx|
with_fx :level, amp: 0 do
  #4.times{sync :start}
  sync :otherhigh
  with_fx :reverb, room: 1.0, mix: 1.0 do
    a5_s = "/Users/josephwilk/.overtone/orchestra/violin/violin_A5_phrase_mezzo-forte_arco-legato.wav"
    a4_s = "/Users/josephwilk/.overtone/orchestra/violin/violin_A4_phrase_mezzo-forte_arco-legato.wav"

    with_fx :slicer, phase: bar/8 do
     sample (ring a4_s, a5_s)[vio_idx], amp: 2.5, pan: Math.sin((vio_pan))
    end 
#    sample v_s, amp: 90
  end
end
vio_pan += 1
vio_idx += 1
end
live_loop :piano do
with_fx :level, amp: 0 do
  sync :quart
  use_synth :beep
  with_fx :reverb do
    sample pa_s, amp: 2, rate: -1
    play degree(1, :A3, :minor), amp: 1.0, attack: 0.001, release: 0.01, decay: 0.1
    sleep bar/2
    #play degree(1, :A5, :minor), amp: 1.0, attack: 0.001, release: 0.01, decay: 0.1
    sleep bar/4
    #play degree(1, :A5, :minor), amp: 1.0, attack: 0.001, release: 0.01, decay: 0.1   
  end
end
end
live_loop :chords do
with_fx :level, amp: 1 do
 sync :start
 with_fx :reverb, room: 0.8, mix: 0.5 do
 #with_fx :slicer, phase: bar/2 do
 use_synth :tri #:dsaw
 play chord_degree(4, :A2, :major)[0], decay: bar*2, release: 1, attack: 0.2, amp: 0.2
 sleep bar/2
 play chord_degree(4, :A2, :major)[1..2], decay: bar*2, release: 1, attack: 0.2, amp: 0.2
 sync :start
 play chord_degree(4, :A2, :major)[1..2], decay: bar*2, release: 1, attack: 0.2, amp: 0.2
 #end
 end
end
end
live_loop :peeep do
with_fx :level, amp: 0.25 do
  3.times {sync :quart}
  use_synth :beep    #:mod_pulse #:mod_beep
  use_synth_defaults cutoff: 100, res: 1.001, amp: 0.8
  with_fx :reverb do

    with_fx :echo, phase: bar/2 do |e|
    #with_fx :pan, pan: 0.25 do
    control e, phase: bar/2 + 0.1
    play degree(4, :A4, :major), amp: 1.0, attack: 0.05, release: 0.5, decay: bar
    sleep bar
    control e, phase: bar/2  + 0.2
    play degree(1, :A5, :major), amp: 0.9, attack: 0.01, release: 0.1, decay: bar/2
    sleep bar/2
    control e, phase: bar/2 +  0.4
    play degree(1, :A5, :major), amp: 0.9, attack: 0.01, release: 0.1, decay: bar/2
    sleep bar/2

    with_synth :mod_pulse do
    with_fx :distortion, mix: 0.01 do
      #play chord_degree(6, :A3, :major)[0..2], decay: bar*2, amp: 0.3
    end
    end

    sleep bar
    control e, phase: bar/2 +  0.1
    play degree(5, :A4, :major), amp: 1.0, attack: 0.01, release: 0.09, decay: bar/4
    sleep bar/2
    control e, phase: bar/2 +  0.03
    play degree(5, :A4, :major), amp: 1.0, attack: 0.01, release: 0.09, decay: bar/4
    sleep bar/2
    control e, phase: bar/2 +  0.05
    play degree(5, :A4, :major), amp: 1.0, attack: 0.05, release: 0.5, decay: bar
    end
    
    sleep bar*2

    sleep bar/2
    sync :quart
    
    sleep bar
    sleep bar/2
    sleep bar/2
   
    sleep bar*2
    play degree(4, :A3, :major), amp: 1.1, attack: 0.001, release: 0.1, decay: bar/2 + 0.05
    sleep bar/4
    with_fx :echo, phase: bar/8 do
      play degree(4, :A5, :major), amp: 1.0, attack: 0.01, release: 1.0, decay: dice(6) > 3 ? bar*4 : bar/2 + 0.05
      with_fx :distortion, mix: 0.01 do
        play chord_degree(6, :A3, :major)
      end

    end
    sleep bar/4
    end
end
end

live_loop :thebass do
with_fx :level, amp: 0.5 do
  use_synth :tri
  sync :start

  with_fx :echo, mix: 0.2 do
    with_fx :reverb, room: 0.9, room_slide: 2 do |r|
      with_fx :distortion, mix: 0.5 do
        play chord_degree(4, :A2, :major).first, amp: 0.4, attack: 0.001, release: 0.5, decay: 1.5, sustain: 1.5      
        sleep bar/2
        with_synth(:tri){play chord_degree(4, :A1, :major).first, amp: 0.4, attack: 0.001, release: 0.5, decay: 1.5, sustain: 1.5}              
      end

      4.times{sync :start;  cue :high}

      control(r, room: 0.5)
      with_fx :distortion, mix: 0.2 do
        play chord_degree(4, :A2, :major).first, amp: 0.4, attack: 0.001, release: 0.5, decay: 1.5, sustain: 1.5      
        sleep bar/2
        with_synth(:tri){play chord_degree(4, :A1, :major).first, amp: 0.4, attack: 0.001, release: 0.5, decay: 1.5, sustain: 1.5}              
      end

      2.times{sync :start}
      control(r, room: 0.3)
      with_fx :distortion, mix: 0.2 do
        play chord_degree(4, :A1, :major).first, amp: 1.15, attack: 0.001, release: 0.5, decay: 1.5, sustain: 1.5
        with_synth(:tri){play chord_degree(4, :A1, :major).first, amp: 1.2, attack: 0.001, release: 0.5, decay: 1.5, sustain: 1.5}              
      end
    end
  end

  2.times{sync :start; cue :otherhigh}
end
end

live_loop :dark do
with_fx :level, amp: 0 do
  use_synth :beep
  sync :start
  with_fx(:reverb, room: 1, mix: 1){sample p_a2_s, amp: 2, rate: 0.99}
  sample :ambi_lunar_land, rate: 0.25, amp: 0.9
  play degree(:i, :A1, :major), attack: 0.1, release: bar*4, decay: bar*4, amp: 8
  use_synth :noise
  play degree(:i, :A1, :major), release: bar*4, amp: 0.1
  #32.times{ sync :start }
end
end

define :beeper do |note, direction, room_size, cutoff, detune_factor1, detune_factor2|
  use_synth :mod_fm  #:mod_fm # sample v_s, amp: 90
  use_synth_defaults detune: 0.0, sustain_level: 0.20, res: 1, env_curve: 7 ,sustain: 1.0, attack: 0.01, decay: 0.15, amp: 1.0, release: 0.5, attack_level: 0.8, mod_phase: 2
  #with_fx :reverb, room: 0.5+0.5*Math.sin(note), mix: 0.5 do

  with_fx :reverb, mix_slide: 2 do |r|
    with_fx :lpf, cutoff: cutoff, cutoff_slide: 20 do |c|
      with_fx :distortion, distort: 0.1, cutoff: 90 do |d|
        n_cut = rrand(30,cutoff);
        n_mix = 0.4
        control(c, cutoff: n_cut);
        7.times do |n|
          control(r, room: 0.1, mix: n_mix) ; control(d, distort: 0.5); play note, attack: 0.001,  pan: 0.8*direction, detune: detune_factor1
          sample :elec_soft_kick, rate: 1, start: 0.1

          sleep bar/2
          control(r, room: 0.3, mix:  n_mix); control(d, distort: 0.25); play note, attack: 0.001, pan: 0.7*direction, detune: detune_factor1
          sample :elec_soft_kick, rate: 1, start: 0.1

          n_cut += cutoff/(4*7); control(c, cutoff: n_cut);

          sleep bar/2
          control(r, room: 0.8, mix:  n_mix); play note, attack: 0.005, pan: 0.6*direction, detune: detune_factor2
          sample :elec_soft_kick, rate: 1, start: 0.1

          sleep bar/2
          control(r, room: 1.0, mix:  n_mix); control(d, distort: 0.0); play note, attack: 0.005,  pan: 0.5*direction, detune: (detune_factor2+(n*0.001))
          sample :elec_soft_kick, rate: 1, start: 0.1

          sleep bar/2
          n_mix-0.05 unless n_mix < 0.2
        end
        sleep bar/2
      end
    end
  end
end

@cutoff = 100
@direction = 1
room_size = 0

live_loop :beep do
with_fx :level, amp: 1 do
  #  sync :bar
  #-10.0, -5.0
  # degree(6, :A2, :major)
  #n = [degree(4, :A3, :major)].choose
  n =  [degree(4, :A3, :major)].choose #fm

  #sync :start

  4.times do
    @direction = rand_i(-1..1)

    sync :bar
    beeper n, @direction, 1, 100, 0, 0.001
    room_size += 1
  end
end
end

live_loop :beep2 do |n|
notes = (ring degree(5, :A3, :major), degree(6, :A3, :major))[n]
with_fx :level, amp: 0.1 do
  4.times do |i|
    n = notes[i % 2]
    sync :bar
    beeper n, @direction == -1 ? 0 : 1, 1, 90, 0, 0.01
    room_size += 1
  end
end
n+=1
end

live_loop :vio_dark do
with_fx :level, amp: 1.0 do
sync :start
with_fx :echo do
with_fx :reverb do
a4_long_s = "/Users/josephwilk/.overtone/orchestra/violin/violin_A4_very-long_decrescendo_arco-normal.wav"
#sample a4_long_s, amp: 1, rate: 1.0
sample a4_long_s, amp: 1, rate: 1.0
sleep sample_duration(a4_long_s)
end
end
end
end

live_loop :across_the_night do
with_fx :level, amp: 1.0 do
use_synth :dark_sea_horn
use_synth_defaults amp: 1, release: 8
play degree(4, :A2, :major)
16.times{sync :bar}
play degree(6, :A2, :major)
16.times{sync :bar}
play degree(5, :A2, :major)
16.times{sync :bar}
end
end
#set_volume! 0.0
