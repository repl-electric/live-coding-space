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
def play_darkness(n, bar)
  with_synth(:tri){play n,  amp: 0.1, attack: 1.0, release: bar, decay: bar, sustain: bar/2}
  with_fx(:pitch_shift, pitch_dis: 0.01){with_fx(:reverb, mix: 0.5){with_synth(:prophet){ play n, cutoff: 60, amp: 1.0,  attack: 0.5, release: bar*6, decay: bar*8, sustain: bar*2}}}
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
live_loop :drum do |d_idx|;with_fx :level, amp: 0.0 do
    sync :quart
    with_fx :lpf do
      sample :elec_triangle, amp: 0.5
    end
  end
  d_idx+=1
end
live_loop :piano do |p_idx|;with_fx :level, amp: 0.0 do
    use_synth :beep; use_synth_defaults amp: 0.2, attack: 0.0, release: 0.1, decay: 0.1
#    with_fx :reverb, room: 1.0, mix: 0.1  do
    with_fx :echo, phase: bar/2.0  do |r_fx|
      #sample pa_s, amp: 0.1, rate: (ring -1, 1)[p_idx]
      sync :bar

      with_fx :level, amp: 0.5  do
        notes = deg_seq(*%w{:A3 4 1 1 4  _ _ _ _ 1112 _ _ _ _})
        sleeps = (ring bar)
        bonus_note = deg_seq(*%w{:A3 1})[0]


        play(notes[0], amp: 1.2, attack: 0.1, release: 0.01, decay: 0.1 + rrand(0.0,0.15)) if notes[0]
        sleep sleeps[0]
        play(notes[1], amp: 1.0, attack: 0.1, release: 0.01, decay: 0.1 + rrand(0.0,0.14)) if notes[1]
        sleep sleeps[1]
        play notes[2], amp: 1.0, attack: 0.1, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[2]
        sleep sleeps[2]
        play notes[3], amp: 1.0, attack: 0.1, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[3]

        sync :bar

        play notes[4], amp: 1.2, attack: 0.1, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[4]
        sleep sleeps[3]
        play notes[5], amp: 1.0, attack: 0.1, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[5]
        sleep sleeps[4]
        play notes[6], amp: 1.0, attack: 0.1, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[6]
        sleep sleeps[5]
        play notes[7], amp: 1.0, attack: 0.1, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[7]

        sync :bar
 
        play notes[8], amp: 1.1, attack: 0.1, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[8]
        sleep sleeps[6]
        play notes[9], amp: 1.0, attack: 0.1, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[9]
        sleep sleeps[7]
        play notes[10], amp: 1.0, attack: 0.1, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[10]
        sleep sleeps[8]
        play notes[11], amp: 1.0, attack: 0.1, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[11]

        sync :bar

        play notes[12], amp: 1.1, attack: 0.001, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[12]
        sleep sleeps[9]

        if(p_idx % 2 == 0)
          with_fx :echo, phase: bar do
            play bonus_note[p_idx], amp: 1.0, attack: 0.1, release: bar/2.0, decay: (bar/4)*2 if bonus_note[p_idx]
          end
        else
          play(notes[13], amp: 1.0, attack: 0.1, release: (p_idx % 4) == 0 ? bar/2.0 : 0.01, decay: (p_idx % 4) == 0 ? bar : 0.1) if notes[13]
        end

        sleep sleeps[10]
        play notes[14], amp: 1.0, attack: 0.00001, release: 0.01, decay: 0.01  if notes[14]
        sleep sleeps[11]
        play notes[15], amp: 1.0, attack: 0.00001, release: 0.0001, decay: 0.01  if notes[15]
      end
    end
    #  if (p_idx % 4 == 0)
    #    sync :bar
    #  end
  end
  p_idx+=1
end
#end
live_loop :bright_light do; with_fx :level, amp: 0.0 do
    3.times {sync :quart}
    use_synth :beep    #:mod_pulse #:mod_beep
    use_synth_defaults cutoff: 100, res: 1.001, amp: 0.8
    with_fx :reverb do
      notes = deg_seq(*%w{:A1 3 :A1 1 1 :A1 1 1 1 :A1 1 :A1 _ :A1 _})
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
define :play_rolling do |note, direction, cutoff, detune_factor1, detune_factor2|
  hit_start_min=0.1
  hit_start_max=0.2
  distort_off = true
  drums_on = false
  use_synth :mod_fm  
  use_synth_defaults detune: 0.00, sustain_level: 0.20, res: 1, env_curve: 7 ,sustain: 1.0, attack: 0.01, decay: 0.15, amp: 1.0, release: 0.5, attack_level: 0.8, 
                     mod_phase: 2
  with_fx :reverb, mix_slide: 0.2 do |r_fx|
#  with_fx :echo, phase: bar/1.0 do
    with_fx :lpf, cutoff: cutoff, cutoff_slide: 20 do |c_fx|
      with_fx :distortion, distort: 0.1, cutoff: 90 do |d_fx|
        #sample v_s, amp: 1, rate: 0.6
        n_cut = rrand(30,cutoff);
        n_mix = 0.4
        control(c_fx, cutoff: n_cut);
        8.times do |n|        
          n%2==0 ? sync(:start) : sync(:quart)
        if cutoff > 80 && !distort_off 
          control(r_fx, room: 0.8, mix: n_mix) ; control(d_fx, distort: 0.5);
        end
          play note, attack: 0.001,  pan: 0.8*direction, detune: detune_factor1
          sample :elec_soft_kick, rate: 1, start: rrand(hit_start_min,hit_start_max) if drums_on

          sleep bar/2
        if cutoff > 80 && !distort_off
          control(r_fx, room: 0.8, mix:  n_mix); control(d_fx, distort: 0.25)
        end
          play note, attack: 0.001, pan: 0.7*direction, detune: detune_factor1
          sample :elec_soft_kick, rate: 1, start: rrand(hit_start_min,hit_start_max+0.2)  if drums_on

          n_cut += cutoff/(4*7); control(c_fx, cutoff: n_cut);

          sleep bar/2
        if cutoff > 80 && !distort_off
       #  control(r_fx, room: 0.8, mix:  n_mix)
          end
          play note, attack: 0.005, pan: 0.6*direction, detune: detune_factor2
          sample :elec_soft_kick, rate: 1, start: rrand(hit_start_min,hit_start_max)  if drums_on

          sleep bar/2
          if cutoff > 80 && !distort_off
          control(r_fx, room: 1.0, mix:  n_mix); control(d_fx, distort: 0.0)
          end
          play note, attack: 0.005,  pan: 0.5*direction, detune: (detune_factor2+(n*0.005))
          sample :elec_soft_kick, rate: 1, start: rrand(hit_start_min,hit_start_max+0.2)  if drums_on

          n_mix-0.09 unless n_mix < 0.2
        end
       # sample :elec_soft_kick, rate: 1, start: rrand(hit_start_min,hit_start_max)
end;end;end;end;
#end
live_loop :rolling_left do |idx|; with_fx :level, amp: 0.0 do
    notes = deg_seq(*%w[:A2 1531 4333 :A3 1511 :A2 7])
 #   notes = deg_seq(*%w[:A3 451])

    1.times {
      play_rolling notes[idx], (ring -1,1)[idx], cut=20, detune1=0, detune2=0.001
    }
  end
  idx+=1
end
live_loop :rolling_right do |idx|;with_fx :level, amp: 0.5 do
#    notes = deg_seq(*%w[:A2 3753 7511 :A3 353 :A2 1])
    notes = deg_seq(*%w[:A3 156])

    cue :flow
    1.times{play_rolling notes[idx],(ring 1,-1)[idx], cut=10, detune1=0, detune2=0.0001}
  end
  idx+=1
end
live_loop :continuous_flow do |s_idx|; with_fx :level, amp: 0.0 do
    with_fx :pitch_shift, pitch_dis: 0.01 do
      with_fx :reverb do
        with_synth :prophet do
          1.times{sync :start}
          chord_name = '7sus4'
          notes = (ring chord(:a2, chord_name)[0], chord(:a2, chord_name)[0], chord(:a2, chord_name)[0], chord(:a2, chord_name)[0],
                        chord(:a2, chord_name)[1], chord(:a2, chord_name)[1], chord(:a2, chord_name)[1], chord(:a2, chord_name)[1],
                        chord(:a2, chord_name)[2], chord(:a2, chord_name)[2], chord(:a2, chord_name)[2], chord(:a2, chord_name)[2])

           notes = (ring chord(:a4, '7sus4')[0])

        play notes[s_idx], cutoff: 60, attack: 1.0, release: (ring bar*4, bar*3)[s_idx], decay: (ring bar*4, bar*4)[s_idx], env_curve: 6, res: 0.2, amp: 1.0
        end
      end
    end
    s_idx+=1
end;end

live_loop :melo do |m_idx|;with_fx :level, amp: 0.0 do
sync :start
with_fx :reverb, room: 0.7, dry: 1.0, mix: 0.5 do
#with_fx :echo, phase: bar do
#with_synth_defaults attack: 0.01, release: 0.01, decay: 0.1 + rrand(0.0,0.15) do 
notes = deg_seq(*%w{:A3 3161 5141 3131 3141})
play notes[m_idx], amp: 1
#end
end
#end
m_idx+= 1
end;end

live_loop :hl do |idx| with_fx :level, amp: 0.0 do
    sync :flow 
    play_darkness deg_seq(*%w{:A2 1235 1215})[idx], bar
    idx+=1
end;end
