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
def deg_seq(*pattern_and_roots)
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
def comment(&_)
end

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

live_loop :highlights do |high_n|;with_fx :level, amp: 0.0 do
    sync :high
    use_synth :sine
    play (ring degree(1, :A4, :major), degree(1, :A3, :major))[high_n]
    high_n += 1
  end
end
live_loop :drum do |d_idx|;with_fx :level, amp: 1.0 do
    sync :quart
    with_fx :lpf do
      sample :elec_triangle, amp: 0.5
    end
  end
  d_idx+=1
end
vio_pan = -1
live_loop :vio do |vio_idx|;with_fx :level, amp: 0.0 do
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
live_loop :piano do |p_idx|;with_fx :level, amp: 1.0 do
    use_synth :beep; use_synth_defaults amp: 0.3, attack: 0.001, release: 0.01, decay: 0.1
    with_fx :reverb, room: 1.0, dry: 1.0, mix: 0.6 do |r_fx|
      sample pa_s, amp: 0.1, rate: (ring -1, 1)[p_idx]
      sync :bar

      if(p_idx %2 == 0)
        with_synth :prophet do
          #          play degree(1, :A2, :minor), cutoff: 70, release: bar, decay: bar*8, env_curve: 6, res: 0.2
        end
      end
      with_fx :level, amp: 1.0  do
        if p_idx % 4 <= 2
          notes = deg_seq(*%w{:a3 1 :a4 211 :a3 1 a4 311 :a3 1 :a4 111 :a3 1 :a4 311})
        else
          notes = deg_seq(*%w{:a3 2 :a4 222 :a3 2 a4 322 :a3 2 :a4 222 :a3 2 :a4 322})
        end
        notes = deg_seq(*%w{:a3 6666 7777 6666 7777})
        if p_idx % 4 <= 2
          notes = deg_seq(*%w{:a3 5 5 5 5 7 7 7 7 6 6 6 6 7 7 7 7})
        else
          notes = deg_seq(*%w{:a3 5 5 5 5 :a4 1 :a3 7 7 6 6 6 6 7 7 7 7})
        end

        bonus_note = (ring degree(5, :a3, :minor))
        sleeps = (ring bar/2.0, bar/2.0, bar/4.0,
                  bar/2.0, bar/2.0, bar/4.0,
                  bar/2.0, bar/2.0, bar/4.0,
                  bar/2.0, bar/2.0, bar/4.0)

        if p_idx % 32 == 0
          notes = deg_seq(*%w{:ah3 _ _ 5 5 _ _ 4 4 _ _ 6 6 _ _ 4 4})
          bonus_note = (ring degree(3, :a3, :minor))

        elsif p_idx % 32 >= 16
          notes = deg_seq(*%w{:ah3 1 1 1 6 1 1 1 5 1 1 1 6 1 1 1 7})
          bonus_note = (ring degree(5, :a3, :minor))

          sleeps = (ring bar, bar, bar/2,
                    bar, bar, bar/2,
                    bar, bar, bar/2,
                    bar, bar, bar/2)

        else
          notes = dez_seq(*%w{:ah3 _ _ 5 5 _ _ 4 4 _ _ 1 1 _ _ 4 4})
          bonus_note = (ring degree(2, :a3, :minor))

        end

        play notes[0], amp: 1.2, attack: 0.001, release: 0.01, decay: 0.1 + rrand(0.0,0.15)
        sleep sleeps[0]
        play notes[1], amp: 1.0, attack: 0.001, release: 0.01, decay: 0.1 + rrand(0.0,0.14)
        sleep sleeps[1]
        play notes[2], amp: 1.0, attack: 0.001, release: 0.01, decay: 0.1 + rrand(0.0,0.15)
        sleep sleeps[2]
        play notes[3], amp: 1.0, attack: 0.001, release: 0.01, decay: 0.1 + rrand(0.0,0.15)

        sync :bar

        play notes[4], amp: 1.2, attack: 0.001, release: 0.01, decay: 0.1 + rrand(0.0,0.15)
        sleep sleeps[3]
        play notes[5], amp: 1.0, attack: 0.001, release: 0.01, decay: 0.1 + rrand(0.0,0.15)
        sleep sleeps[4]
        play notes[6], amp: 1.0, attack: 0.001, release: 0.01, decay: 0.1 + rrand(0.0,0.15)
        sleep sleeps[5]
        play notes[7], amp: 1.0, attack: 0.001, release: 0.01, decay: 0.1 + rrand(0.0,0.15)

        sync :bar

        play notes[8], amp: 1.1, attack: 0.001, release: 0.01, decay: 0.1 + rrand(0.0,0.15)
        sleep sleeps[6]
        play notes[9], amp: 1.0, attack: 0.001, release: 0.01, decay: 0.1 + rrand(0.0,0.15)
        sleep sleeps[7]
        play notes[10], amp: 1.0, attack: 0.001, release: 0.01, decay: 0.1 + rrand(0.0,0.15)
        sleep sleeps[8]
        play notes[11], amp: 1.0, attack: 0.001, release: 0.01, decay: 0.1 + rrand(0.0,0.15)

        sync :bar

        play notes[12], amp: 1.1, attack: 0.001, release: 0.01, decay: 0.1 + rrand(0.0,0.15)
        sleep sleeps[9]

        if(p_idx % 2 == 0)
          with_fx :echo, phase: bar do
            play bonus_note[p_idx], amp: 1.0, attack: 0.001, release: bar/2.0, decay: (bar/4)*2
          end
        else
          play notes[13], amp: 1.0, attack: 0.001, release: (p_idx % 4) == 0 ? bar/2.0 : 0.01, decay: (p_idx % 4) == 0 ? bar : 0.1

        end

        sleep sleeps[10]
        play notes[14], amp: 1.0, attack: 0.00001, release: 0.01, decay: 0.01
        sleep sleeps[11]
        play notes[15], amp: 1.0, attack: 0.00001, release: 0.0001, decay: 0.01
      end
    end
    #  if (p_idx % 4 == 0)
    #    sync :bar
    #  end
  end
  p_idx+=1
end
live_loop :bright_light do; with_fx :level, amp: 0.0 do
    3.times {sync :quart}
    use_synth :beep    #:mod_pulse #:mod_beep
    use_synth_defaults cutoff: 100, res: 1.001, amp: 0.8
    with_fx :reverb do
      notes = deg_seq(*%w{:A1 3 :A3 1 1 :A3 1 1 1 :A3 1 :A2 _ :A2 _})
      with_fx :echo, phase: bar/2 do |e|
        #with_fx :pan, pan: 0.25 do
        control e, phase: bar/2 + 0.1
        play notes[0], amp: 1.0, attack: 0.05, release: 0.5, decay: bar
        sleep bar
        control e, phase: bar/2  + 0.2
        play notes[1], amp: 0.9, attack: 0.01, release: 0.1, decay: bar/2
        sleep bar/2
        control e, phase: bar/2 +  0.4
        play notes[2], amp: 0.9, attack: 0.01, release: 0.1, decay: bar/2
        sleep bar/2

        with_synth :mod_pulse do
          with_fx :distortion, mix: 0.01 do
            #play chord_degree(6, :A3, :major)[0..2], decay: bar*2, amp: 0.3
          end
        end

        sleep bar
        control e, phase: bar/2 +  0.1
        play notes[3], amp: 1.0, attack: 0.01, release: 0.09, decay: bar/4
        sleep bar/2
        control e, phase: bar/2 +  0.03
        play notes[4], amp: 1.0, attack: 0.01, release: 0.09, decay: bar/4
        sleep bar/2
        control e, phase: bar/2 +  0.05
        play notes[5], amp: 1.0, attack: 0.05, release: 0.5, decay: bar
      end

      sleep bar*2

      sleep bar/2
      sync :quart

      sleep bar
      sleep bar/2
      sleep bar/2

      sleep bar*2
      play notes[6], amp: 1.1, attack: 0.001, release: 0.1, decay: bar/2 + 0.05
      sleep bar/4
      with_fx :echo, phase: bar/8 do
        play notes[7], amp: 1.0, attack: 0.01, release: 1.0, decay: dice(6) > 3 ? bar*4 : bar/2 + 0.05
        with_fx :distortion, mix: 0.01 do
          play notes[8]
        end
      end
      sleep bar/4
    end
  end
end

live_loop :dark_humming do |n_idx|
  #sync :start
  with_fx :level, amp: 3.0 do
    with_synth :dark_ambience do
      with_fx :lpf, cutoff: 65 do
        with_fx :reverb, room: 0.0 do
          sync :start
          play (ring
                chord_degree(5, :A1)[0],
                chord_degree(4, :A1)[0],
                chord_degree(3, :A1)[0],
                chord_degree(1, :A1)[0],

                chord_degree(3, :A1)[1],
                chord_degree(4, :A1)[0],
                chord_degree(3, :A1)[0],
                chord_degree(1, :A2)[0],
                )[n_idx], release: (ring bar*4, bar*4, bar*4, bar*8)[n_idx], attack: 0.1
        end
      end
    end
  end
  n_idx+=1
end
live_loop :dark_highlight do |n_idx|
  with_fx :level, amp: 0.0 do
    with_synth :dark_ambience do
      #with_fx :lpf, cutoff: 100 do
      with_fx :reverb, room: 0.0 do
        sync :start
        play (ring
              chord_degree(1, :a3, :major)[0],nil,nil,nil,
              nil,nil,nil,chord_degree(4, :a2, :major)[0],
              #
              chord_degree(1, :a4, :major)[0],chord_degree(1, :a3, :major)[0],nil, chord_degree(4, :a2, :major)[0],
              nil,nil,nil,chord_degree(4, :a2, :major)[0],
              #
              chord_degree(5, :a3, :major)[0],nil,nil,nil,
              nil,nil,nil,chord_degree(4, :a3, :major)[0],
        )[n_idx], release: (ring bar*4, bar*4, bar*4, bar*6)[n_idx], attack: 0.28,
          amp: (ring 1.0, 1.0, 1.0, 1.0, 1.5, 1.5, 1.5,1.5)[n_idx]
      end
    end
    #end
  end
  n_idx+=1
end

define :play_rolling do |note, direction, room_size, cutoff, detune_factor1, detune_factor2|
  use_synth :mod_fm  #:mod_fm # sample v_s, amp: 90
  use_synth_defaults detune: 0.05, sustain_level: 0.20, res: 1, env_curve: 7 ,sustain: 1.0, attack: 0.01, decay: 0.15, amp: 1.0, release: 0.5, attack_level: 0.8, mod_phase: 2
  #with_fx :reverb, room: 0.5+0.5*Math.sin(note), mix: 0.5 do

  with_fx :reverb, mix_slide: 0.2 do |r|
    with_fx :lpf, cutoff: cutoff, cutoff_slide: 20 do |c|
      with_fx :distortion, distort: 0.1, cutoff: 90 do |d|
        n_cut = rrand(30,cutoff);
        n_mix = 0.4
        control(c, cutoff: n_cut);
        8.times do |n|

          if n%2 ==0
            sync :start
          else
            sync :quart
          end

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
          control(r, room: 1.0, mix:  n_mix); control(d, distort: 0.0); play note, attack: 0.005,  pan: 0.5*direction, detune: (detune_factor2+(n*0.005))
          sample :elec_soft_kick, rate: 1, start: 0.1

          n_mix-0.09 unless n_mix < 0.2
        end
        sample :elec_soft_kick, rate: 1, start: 0.1
end;end;end;end

@cutoff = 10
@direction = 1
room_size = 0

live_loop :rolling_left do |b_idx|; with_fx :level, amp: 1.0 do
    notes = deg_seq(*%w[:A2 541]) #fm
    2.times do
      @direction = rand_i(-1..1)
      play_rolling notes[b_idx], dir=@direction, room=1, cut=70, detune1=0, detune2=0.001
      room_size += 1
    end
  end
  b_idx+=1
end

live_loop :rolling_right do |n_idx|;with_fx :level, amp: 1.0 do
    notes = deg_seq(*%w[:A2 165])
    cue :high_to_low if notes[n_idx] == degree(5, :A2, :major)
    cue :low_to_high if notes[n_idx] ==  degree(6, :A2, :major)
    2.times do |i|
      play_rolling notes[n_idx], @direction == -1 ? 1 : 0, room=1, cut=60, detune1=0, detune2=0.01
      room_size += 1
    end
  end
  n_idx+=1
end

#live_loop :across_the_night do
#with_fx :level, amp: 0.0 do
#sync :start
#play degree(4, :A3, :major);16.times{sync :bar}
#play degree(6, :A3, :major);16.times{sync :bar}
#play degree(5, :A3, :major);16.times{sync :bar}
#play degree(1, :A3, :major);16.times{sync :bar}
#end
#end

#live_loop :drums do
#sync :quart

#end

live_loop :continuous_flow do |s_idx|; with_fx :level, amp: 1 do
    with_fx :pitch_shift, pitch_dis: 0.01 do
      with_fx :reverb, room: 0.5 do
        with_synth :prophet do
          4.times{sync :start}
          notes = (ring chord(:a1, '7sus4')[0],
                        chord(:a1, '7sus4')[1])
        play notes[s_idx], cutoff: 60, attack: 1.0, release: (ring bar*4, bar*3)[s_idx], decay: (ring bar*4, bar*4)[s_idx], env_curve: 6, res: 0.2, amp: 1.0
          #with_synth(:sine){ play notes[s_idx],  attack: 1.0, release: bar, decay: bar*8, env_curve: 6, res: 0.2, amp: 1.0  }
        end
       
        #        with_fx :reverb, room: 1.0, damp: 1.0, mix: 0.0 do
        #        with_fx :pitch_shift, pitch_dis: 0.1, time_dis: 0.1 do
        #        with_fx :echo, phase: bar/8, decay: bar do
        #        with_fx :hpf, cutoff: 100 do
        #        with_synth :pnoise do
        #play degree((ring 4,1)[s_idx], :A0, :minor), release: bar/2, decay: bar/2, env_curve: 6, res: 0.2, attack: 2.0
        #        end;end;end;end;end
      end
    end
#    1.times{sync :start}
        
    s_idx+=1
end;end

def play_darkness(n, bar)
  with_synth(:tri){play n,  amp: 0.0, attack: 1.0, release: bar, decay: bar, sustain: bar/2}
  with_fx(:pitch_shift, pitch_dis: 0.01){with_fx(:reverb, mix: 0.5){with_synth(:prophet){ play n, cutoff: 60, amp: 1.0,  attack: 0.5, release: bar*6, decay: bar*8, sustain: bar*2}}}
end

live_loop :hl do |idx| with_fx :level, amp: 3.0 do
    sync :high_to_low
    play_darkness deg_seq(*%w{:a2 13})[idx],bar
    idx+=1
end;end

live_loop :lh do |idx|;with_fx :level, amp: 3.0 do
    sync :low_to_high
    play_darkness deg_seq(*%w{:a2 25})[idx],bar
    idx+=1
end;end

live_loop :thebass do |idx|
  with_fx :level, amp: 0.0 do
    use_synth :tri
    with_fx :echo, mix: 0.2 do; with_fx :reverb, room: 0.9, room_slide: 2 do |r|; with_fx :distortion, mix: 0.7 do
          1.times{sync :start}

          play chord_degree(4, :A2, :harmonic_minor)[0..2], amp: 0.4, attack: 0.09, release: bar*2, decay: bar*4, sustain: bar/2
          4.times{sync :start}

          play chord_degree(2, :A2, :harmonic_minor)[0..2], amp: 0.4, attack: 0.09, release: bar*2, decay: bar*4, sustain: bar/2
          2.times{sync :start}

          play chord_degree(1, :A2, :harmonic_minor)[0..2], amp: 0.4, attack: 0.01, release: bar, decay: bar*8, sustain: bar/2
          sleep bar
          with_synth(:tri){play chord_degree(1, :A1, :harmonic_minor).first, amp: 0.4, attack: 0.001, release: 0.5, decay: 1.5, sustain: 1.5}

          ##        x = (ring *chord(:a1, '7sus2')[1..3])
          #        play x[1],  amp: 0.4, attack: 0.09, release: bar*2, decay: bar*4, sustain: bar/2
          #        with_synth(:prophet){ play x[0], cutoff: 40, amp: 1.0,  attack: 0.3, release: bar*4, decay: bar*4, sustain: bar/2}
          #        2.times{sync :start}
          ###        play x[1], amp: 0.4,  attack: 0.09, release: bar*2, decay: bar*4, sustain: bar/2
          #        with_synth(:prophet){ play x[1], cutoff: 40, amp: 1.0,  attack: 0.3, release: bar*4, decay: bar*4, sustain: bar/2}
          #       2.times{sync :start}
          #       play x[2], amp: 1.0,  attack: 0.09, release: bar*2, decay: bar*2, sustain: bar/2
          #      with_synth(:prophet){ play x[2], cutoff: 58, amp: 1.0,  attack: 0.3, release: bar*4, decay: bar*4, sustain: bar/2}
          #     2.times{sync :start}

          #if idx % 2 == 0
          #       play degree(3, :a1, :harmonic_minor), amp: 1.0, attack: 1.0, release: bar*4, decay: bar*4, sustain: bar/2
          #      with_synth(:prophet){ play degree(3, :a1, :harmonic_minor), cutoff: 60, amp: 1.0,  attack: 0.09, release: bar*2, decay: bar*4, sustain: bar/2}
          #        1.times{sync :start}

          #else
          #       play degree(3, :a1, :harmonic_minor), amp: 1.0, attack: 1.0, release: bar/2, decay: bar/2, sustain: bar/2
          #      with_synth(:prophet){ play degree(3, :a1, :harmonic_minor), cutoff: 55, amp: 1.0,  attack: 0.09, release: bar*2, decay: bar*4, sustain: bar/2}
          #  #      1.times{sync :start}

          #end
        end

        comment do

          1.times{sync :start;  cue :high}

          control(r, room: 0.5)
          with_fx :distortion, mix: 0.2 do
            sync :start
            play chord_degree(1, :A1, :major).first, amp: 0.4, attack: 0.2, release: 0.2, decay: 0.2, sustain: 0.2
            sync :start
            play chord_degree(4, :A1, :major).first, amp: 0.4, attack: 0.2, release: 0.2, decay: 0.2, sustain: 0.2
            sync :start
            with_synth(:tri){play chord_degree(5, :A1, :major).first, amp: 0.4, attack: 0.001, release: 0.5, decay: 1.5, sustain: 1.5}
            sync :start
            play chord_degree(5, :A1, :major).first, amp: 0.4, attack: 0.05, release: 0.1, decay: 0.1, sustain: 0.1
          end

          1.times{sync :start;}

          control(r, room: 0.45)
          with_fx :distortion, mix: 0.2 do
            sync :start
            play chord_degree(1, :A2, :major).first, amp: 0.4, attack: 0.2, release: 0.2, decay: 0.2, sustain: 0.2
            sleep bar/2
            play chord_degree(4, :A2, :major).first, amp: 0.4, attack: 0.2, release: 0.2, decay: 0.2, sustain: 0.2
            sleep bar
            with_synth(:tri){play chord_degree(4, :A1, :major).first, amp: 0.4, attack: 0.001, release: 0.5, decay: 1.5, sustain: 1.5}
            sleep bar
            play chord_degree(4, :A2, :major).first, amp: 0.4, attack: 0.05, release: 0.1, decay: 0.1, sustain: 0.1
          end

          2.times{sync :start}
          control(r, room: 0.3)
          with_fx :distortion, mix: 0.1 do
            play chord_degree(4, :A1, :major).first, amp: 0.4, attack: 0.8, release: 0.5, decay: 1.5, sustain: 1.5
            sleep bar
            with_synth(:tri){play chord_degree(4, :A1, :major).first, amp: 0.3, attack: 0.8, release: 0.5, decay: 1.5, sustain: 1.5}
          end
        end
      end

      3.times{sync :start; cue :otherhigh}
    end
  end
end
