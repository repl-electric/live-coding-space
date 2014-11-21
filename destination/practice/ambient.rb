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

live_loop :drum do
  sync :quart
  with_fx :lpf do
    sample :elec_triangle, amp: 0.2
  end
end

live_loop :vio do
  4.times{sync :start}
  with_fx :reverb, room: 1.0, mix: 1.0 do
    sample v_s, amp: 90
  end
end

live_loop :radio do
  sample radio_s, amp: 8, rate: 0.1
  sleep sample_duration(radio_s)
end

live_loop :piano do
  sync :quart
  use_synth :beep
  with_fx :reverb do
    play degree(1, :A4, :minor), amp: 1.0, attack: 0.001, release: 0.01, decay: 0.1
    sample pa_s, amp: 2

    #    play degree([4,5].choose, :A4, :minor), amp: 1.0, attack: 0.001, release: 0.01, decay: 0.1
    #    sleep bar/4
    #    play degree(4, :A4, :minor), amp: 1.0, attack: 0.001, release: 0.01, decay: 0.1
    #    sleep bar/4
    #    play degree(1, :A4, :minor), amp: 1.0, attack: 0.001, release: 0.01, decay: 0.1   #:A5
  end
end

live_loop :piano2 do
  use_synth :tri
  sync :start

  with_fx :echo, mix: 0.2 do
    with_fx :reverb, room: 0.9, room_slide: 2 do |r|
      with_fx :distortion, mix: 0.5 do
        #with_fx(:reverb, room: 1, mix: 1){sample Piano.note(:a2), amp: 1, rate: 1.0}

        #play chord_degree(1, :A2, :major).take(3), amp: 1.0, attack: 0.01, release: 0.5, decay: 2.0, sustain: 1.8
        play chord_degree(1, :A2, :major)[0], amp: 1.0, attack: 0.01, release: 0.5, decay: 2.0, sustain: 1.5
        sleep bar/2
        with_synth(:tri){ play chord_degree(1, :A2, :major)[1], amp: 1.0, attack: 0.01, release: 0.5, decay: 2.0, sustain: 1.5}
      end

      4.times{sync :start}

      control(r, room: 0.5)
      with_fx :distortion, mix: 0.2 do
        #sample Piano.note(:c2)

        play chord_degree(1, :A2, :major)[0], amp: 1.1, attack: 0.01, release: 0.5, decay: 1.5, sustain: 1.0
        sleep bar/2
        with_synth(:tri){play chord_degree(1, :A2, :major)[2], amp: 1.1, attack: 0.01, release: 0.5, decay: 1.5, sustain: 1.0}
      end

      2.times{sync :start}
      control(r, room: 0.3)
      with_fx :distortion, mix: 0.2 do
        #sample Piano.note(:c2)

        play chord_degree(4, :A1, :major).first, amp: 1.15, attack: 0.001, release: 0.5, decay: 1.5, sustain: 1.5
        with_synth(:tri){play chord_degree(4, :A1, :major).first, amp: 1.2, attack: 0.001, release: 0.5, decay: 1.5, sustain: 1.5}
      end
    end
  end

  2.times{sync :start}
end

live_loop :dark do
  use_synth :beep
  sync :start
  with_fx(:reverb, room: 1, mix: 1){sample p_a2_s, amp: 4, rate: 0.99}
  sample :ambi_lunar_land, rate: 0.25, amp: 0.9
  play degree(:i, :A1, :major), attack: 0.1, release: bar*4, decay: bar*4, amp: 8
  use_synth :noise
  play degree(:i, :A1, :major), release: bar*4, amp: 0.1
  16.times{ sync :start }
end

define :beeper do |note, direction, room_size, cutoff, detune_factor1, detune_factor2|
  use_synth :mod_dsaw #:mod_saw
  use_synth_defaults detune: 0.0, sustain_level: 0.20, res: 1, env_curve: 7 ,sustain: 1.0, attack: 0.01, decay: 0.15, amp: 1.0, release: 0.5, attack_level: 0.8
  #with_fx :reverb, room: 0.5+0.5*Math.sin(note), mix: 0.5 do

  with_fx :reverb do |r|
    with_fx :lpf, cutoff: cutoff, cutoff_slide: 20 do |c|
      with_fx :distortion, distort: 0.1, cutoff: 90 do |d|
        n_cut = rrand(50,cutoff);
        control(c, cutoff: n_cut);
        7.times do |n|
          control(r, room: 0.1) ; control(d, distort: 0.5); play note, attack: 0.001,  pan: 0.8*direction, detune: detune_factor1
          sample :elec_soft_kick, rate: 1, start: 0.1

          sleep bar/2
          control(r, room: 0.3, distort: 0.5); play note, attack: 0.001, pan: 0.7*direction, detune: detune_factor1
          sample :elec_soft_kick, rate: 1, start: 0.1

          n_cut += cutoff/(4*7); control(c, cutoff: n_cut);

          sleep bar/2
          control(r, room: 0.8); play note, attack: 0.005, pan: 0.6*direction, detune: detune_factor2
          sample :elec_soft_kick, rate: 1, start: 0.1

          sleep bar/2
          control(r, room: 1.0); control(d, distort: 0.0); play note, attack: 0.005,  pan: 0.5*direction, detune: (detune_factor2+(n*0.001))
          sample :elec_soft_kick, rate: 1, start: 0.1

          sleep bar/2
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
  #  sync :bar

  #-10.0, -5.0
  # degree(6, :A2, :major)

  n =  [degree(6, :A2, :major), degree(4, :A2, :major)].choose
  #sync :start

  4.times do
    @direction = rand_i(-1..1)

    sync :bar
    beeper n, @direction, 1, 100, 0, -5.0
    room_size += 1
  end
end

live_loop :beep2 do
  #  sync :bar
  #-10.0, -5.0
  # degree(6, :A2, :major)

  n =  [degree(6, :A2, :major), degree(4, :A2, :major)].choose
  #sync :start

  4.times do
    sync :bar
    beeper n, @direction < 0 ? 1 : -1, 1, 100, 0, -5.0
    room_size += 1
  end
end

live_loop :deep do
  use_synth :fm
  sync :start
  with_fx :slicer, phase: bar*4 do
    play degree(1, :A1, :major), release: bar*4, decay: bar*4, amp: 0.2
  end
end

n = 0
live_loop :sawnoise do
  use_synth :prophet
  2.times{sync :start}
  1.times do
    with_fx :reverb, room: 1 do
      with_fx :reverb, room: 1 do
        with_fx :reverb, room: 1 do
          with_fx :echo, decay: 1 do
            with_fx :lpf, cutoff: 100 do
              with_fx :hpf, cutoff: 110 do
                play degree([1,3].choose, :A1, :minor), release: bar*4, decay: bar*4, amp: 1.0
  end end end end end end end
  n+= 1
end

#begone :deep
#begone :vio
#begone :deep
#begone :beep
#begone :piano
#begone :dark
#begone :radio
#begone :sawnoise


#3.times do
#  control(r, room: 0.1) ; control(d, distort: 0.5)
#  play note, attack: 0.001,  pan: 0.8*direction,  decay: (bar/2)*6, release: bar*6, detune: 0.0
#  sleep bar/2
#  control(r, room: 0.3, distort: 0.5);

#  play note, attack: 0.001, pan: 0.7*direction, detune: 0.0
#  sleep bar/2
#  control(r, room: 0.8)
#  play note, attack: 0.01,  pan: 0.6*direction, release: 0.5, decay: (bar/2), detune: detune_factor
#  sleep bar/2
#  control(r, room: 1.0); control(d, distort: 0.0)
#  play note, attack: 0.01,  pan: 0.5*direction, release: 0.5, decay: (bar/2)/2, detune: detune_factor
#  sleep bar/2
#end
#  sleep bar/2
#
# end
# end
#  end
