["piano"].each{|f| require "/Users/josephwilk/Workspace/repl-electric/sonic-pi/lib/#{f}"}
bar = 1/2.0
quart = 2*bar
set_volume! 3.0
pa_s = "/Users/josephwilk/Dropbox/repl-electric/samples/pi/piano_a.wav"
p_c3_s = "/Users/josephwilk/Dropbox/repl-electric/samples/pi/148600__neatonk__piano-med-c3.wav"
p_a2_s = "/Users/josephwilk/Dropbox/repl-electric/samples/pi/148533__neatonk__piano-med-a2.wav"
p_c4_s = "/Users/josephwilk/Dropbox/repl-electric/samples/pi/148603__neatonk__piano-med-c4.wav"
v_s = "/Users/josephwilk/.overtone/orchestra/violin/violin_A3_1_piano_arco-normal.wav"
radio_s = "/Users/josephwilk/Dropbox/repl-electric/samples/pi/32266__paracelsus__radio.wav"
def ambi_s(name)
  s = Dir["/Users/josephwilk/Dropbox/repl-electric/samples/ambience\ \&\ found\ sound/*.wav"]
  s.sort!
  if name.is_a? Integer
    s[name]
  else
  s.select{|s| s =~ /#{name}/}[0]
  end
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
  cue :whole; cue :half;  cue :quarter; cue :eighth
  sleep bar/2.0
  cue :eighth
  sleep bar/2.0
  cue :quarter; cue :eighth
  sleep bar/2.0
  cue :eighth
  sleep bar/2.0
  cue :half; cue :quarter; cue :eighth
  sleep bar/2.0
  cue :eighth
  sleep bar/2.0
  cue :quarter; cue :eighth
  sleep bar/2.0
  cue :eighth
  sleep bar/2.0
end
def play_rollinz(n, dir)
  use_synth :mod_fm  #:mod_fm # sample v_s, amp: 90
  use_synth_defaults detune: 0.05, sustain_level: 0.20, res: 1, env_curve: 7 ,sustain: 1.0, attack: 0.01, decay: 0.15, amp: 1.0, release: 0.5, attack_level: 0.8, mod_phase: 0
  with_fx :reverb, mix_slide: 0.2 do |r|; with_fx :distortion, distort: 0.1, cutoff: 90 do
      play n, attack: 0.001,  pan: 0.8*dir, detune: 0.001
end;end;end
@piano_amp = 0.0
live_loop :piano do |p_idx|;with_fx :level, amp: @piano_amp do
    use_synth :beep; use_synth_defaults amp: 0.2, attack: 0.0, release: 0.1, decay: 0.1
    #with_fx :reverb, room: 1.0, mix: 0.1  do
    with_fx :echo, phase: bar/2.0  do |r_fx|
      #sample pa_s, amp: 0.1, rate: (ring -1, 1)[p_idx]
      sync :quarter
      with_fx :level, amp: 0.3  do
        notes = deg_seq(*%w{:A3 1 _ _ _   :A4 1 _ _ _}) #4 1 1 4  _ _ _ _ 1112 _ _ _ _
        sleeps = (ring bar)
        bonus_note = deg_seq(*%w{:A3 1})[0]


        play(notes[0], amp: 1.2, attack: 0.09, release: 0.01, decay: 0.1 + rrand(0.0,0.15)) if notes[0]
        sleep sleeps[0]
        play(notes[1], amp: 1.0, attack: 0.1, release: 0.01, decay: 0.1 + rrand(0.0,0.14)) if notes[1]
        sleep sleeps[1]
        play notes[2], amp: 1.0, attack: 0.1, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[2]
        sleep sleeps[2]
        play notes[3], amp: 1.0, attack: 0.1, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[3]

        sync :quarter

        play notes[4], amp: 1.2, attack: 0.09, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[4]
        sleep sleeps[3]
        play notes[5], amp: 1.0, attack: 0.1, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[5]
        sleep sleeps[4]
        play notes[6], amp: 1.0, attack: 0.1, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[6]
        sleep sleeps[5]
        play notes[7], amp: 1.0, attack: 0.1, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[7]

        sync :quarter

        play notes[8], amp: 1.1, attack: 0.09, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[8]
        sleep sleeps[6]
        play notes[9], amp: 1.0, attack: 0.1, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[9]
        sleep sleeps[7]
        play notes[10], amp: 1.0, attack: 0.1, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[10]
        sleep sleeps[8]
        play notes[11], amp: 1.0, attack: 0.1, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[11]

        sync :quarter

        play notes[12], amp: 1.1, attack: 0.01, release: 0.01, decay: 0.1 + rrand(0.0,0.15) if notes[12]
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
  end
  p_idx+=1
end
live_loop :bright_light do; with_fx :level, amp: @brightlight_amp do
    3.times {sync :half}
    use_synth :beep    #:mod_pulse #:mod_beep
    use_synth_defaults cutoff: 100, res: 1.001, amp: 0.8
    with_fx :reverb do
      notes = deg_seq(*%w{:A1 3 :A2 4 4 :A2 1 1 1 :A2 1 :A1 _ :A1 _})
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
      sync :half

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
define :play_rolling do |notes, sleeps, direction, cutoff, detune_factor1, detune_factor2|
  hit_start_min=0.5
  hit_start_max=0.6
  distort_on = true
  drums_on = true
  use_synth :mod_fm
  use_synth_defaults detune: 0.00, sustain_level: 0.20, res: 1, env_curve: 7 ,sustain: 1.0, attack: 0.01, decay: 0.15, amp: 1.0, release: 0.5, attack_level: 0.8,
    mod_phase: 0
  with_fx :reverb, mix_slide: 0.2, mix: 0.2 do |r_fx|
    #   with_fx :echo, phase: bar/1.0 do
    with_fx :lpf, cutoff: cutoff, cutoff_slide: 20, mix: 1.0  do |c_fx|
      with_fx :distortion, distort: 0.1, cutoff: 90, mix: 0.1 do |d_fx|
        #sample v_s, amp: 1, rate: 0.6
        n_cut = rrand(30,cutoff);
        n_mix = 0.4
        control(c_fx, cutoff: n_cut);
        8.times do |n|
          n%2==0 ? sync(:whole) : sync(:half)

          if cutoff > 80 && distort_on
            control(r_fx, room: 0.8, mix: n_mix) ; control(d_fx, distort: 0.5);
          end
          play notes[n], attack: 0.01,  pan: 0.8*direction, detune: detune_factor1
          sample :elec_soft_kick, rate: 1, start: rrand(hit_start_min,hit_start_max) if drums_on

          sleep sleeps[n*3 + 0]
          if cutoff > 80 && distort_on
            control(r_fx, room: 0.8, mix:  n_mix); control(d_fx, distort: 0.25)
          end
          play notes[n+1], attack: 0.003, pan: 0.7*direction, detune: detune_factor1
          sample :elec_soft_kick, rate: 1, start: rrand(hit_start_min,hit_start_max+0.2)  if drums_on

          n_cut += cutoff/(4*7); control(c_fx, cutoff: n_cut);

          sleep sleeps[n*3 + 1]
          if cutoff > 80 && distort_on
            control(r_fx, room: 0.8, mix:  n_mix)
          end
          play notes[n+2], attack: 0.002, pan: 0.6*direction, detune: detune_factor2
          sample :elec_soft_kick, rate: 1, start: rrand(hit_start_min,hit_start_max)  if drums_on

          sleep sleeps[n*3 + 2]
          if cutoff > 80 && distort_on
            control(r_fx, room: 1.0, mix:  n_mix); control(d_fx, distort: 0.0)
          end
          play notes[n+3], attack: 0.001,  pan: 0.5*direction, detune: (detune_factor2+(n*0.005))
          sample :elec_soft_kick, rate: 1, start: rrand(hit_start_min,hit_start_max+0.2)  if drums_on

          n_mix-0.09 unless n_mix < 0.2

          #bonus
          #with_synth(:beep){with_fx(:slicer, phase: bar){play deg_seq(*%w{:A3 3161 5141 3131 3141})[n*1+rand_i(1)], attack: 0.01, release: 0.01, decay: 1.0} if  n%2==0}
        end
        sample :elec_soft_kick, rate: 1, start: rrand(hit_start_min,hit_start_max)
end;end;end;end;
live_loop :rolling_left do |idx|; with_fx :level, amp: 0.3 + (ring 0.02,0.01,0.02,0.01)[idx] do
   notes = knit(*chord(:a3, 'sus4')[0..3].reverse.map{|a| [a, 8]}.flatten)
    notes = (ring (deg_seq(*%w[:A2 1457 6543])[idx]))
    #notes = (deg_seq(*%w[:A2 1113 1114]))
    notes = (ring deg_seq(*%w[:A2 1])[idx])

    sleeps = (ring bar/2.0)
    cue :roller
    1.times {play_rolling notes, sleeps, direction=(ring -1,1)[idx], cut=0, detune1=0, detune2=0.001
  } 
  end
  idx+=1
end
live_loop :rolling_right do |idx|;with_fx :level, amp: 0.3 do
    notes = knit(*chord(:a3, 'sus4')[0..3].map{|a| [a, 8]}.flatten)
    #notes = (deg_seq(*%w[:A2 3535 1616]))
    notes = (deg_seq(*%w[:A2 1515 5656 :A3 1 :A2 5 :A3 1 :A2 5]))
    notes = (ring (deg_seq(*%w[:A2 5613 4365])[idx]))
    notes = (ring (deg_seq(*%w[:A2 1])[idx]))

    sleeps = (ring bar/2.0)
    cue :flow
    1.times{play_rolling(notes, sleeps, direction=(ring 1,-1)[idx], cut=0, detune1=0.0, detune2=0.0001)}
  end
  idx+=1
end
#live_loop :hit_it do |idx|;with_fx :level, amp: 0.3 do
#    1.times{play_rolling(ring(deg_seq(*%w[:A2 1])), (ring bar*2.0), direction=(ring 1,-1)[idx], cut=40, detune1=0, detune2=0.001)}
#    idx+=1
#end;end

#1457 6543
#5613 4365
live_loop :bass do |idx|;with_fx :level, amp: 0.0 do
1.times{sync :flow}
with_synth :dark_sea_horn do
with_fx (ring :echo, :none)[idx], phase: (ring bar/2.0)[idx] do
play (ring chord_degree(1, :A1, :major),
           chord_degree(4, :A1, :major),
           chord_degree(4, :A2, :major),
           chord(:E3, :major7),
           chord(:E3, :major7),

           chord_degree(1, :A2, :major),
           chord_degree(3, :A2, :major),
           chord_degree(4, :A2, :major),
           chord_degree(3, :A2, :major)
)[idx], decay: bar*6, attack: 0.5, amp: (ring 0.85, 0.7, 0.8, 0.7)[idx]
end;end;end
idx+=1
end

live_loop :continuous_flow do |s_idx|; with_fx :level, amp: 0.0 do
    with_fx :pitch_shift, pitch_dis: 0.01 do
      with_fx :reverb do
        with_synth :prophet do 
          1.times{sync :whole}
          chord_name = '7sus4'
          root = :a2
          notes = (ring chord(root, chord_name)[0], chord(root, chord_name)[0], chord(root, chord_name)[0], chord(root, chord_name)[0],
                   chord(root, chord_name)[1], chord(root, chord_name)[1], chord(root, chord_name)[1], chord(root, chord_name)[1],
                   chord(root, chord_name)[2], chord(root, chord_name)[2], chord(root, chord_name)[2], chord(root, chord_name)[2])
          #notes = (knit chord(:a3, '7sus4')[2], 8, chord(:a4, '7sus4')[1], 8,
          #              chord(:a3, '7sus4')[2], 16)
          play notes[s_idx], cutoff: 60, attack: 1.0, release: (ring bar*4, bar*3)[s_idx], decay: (ring bar*4, bar*4)[s_idx], env_curve: 6, res: 0.2, amp: 1.0
        end
      end
    end
    s_idx+=1
end;end

#145
#561

live_loop :melo do |m_idx|;with_fx :level, amp: 0.45 do; with_fx :lpf, cutoff: 10, mix: 1.0 do
    #m_idx = (m_idx % 16) #+ 16
    sync :whole
    use_synth :beep
    with_fx :reverb, room: 0.7, dry: 1.0, mix: 0.2 do
      with_fx (ring :echo, :none)[m_idx], phase: bar/8 do
        with_synth_defaults attack: 0.1, release: 1.0, decay: 0.1 + rrand(0.0,0.15) do

#3161 5131 3131 2131
#3161 5131 3131 3211

        notes = deg_seq(*%w{:A3 3161 5131 2121 3131
                                3163 5131 3131 4121})
                  
#        notes = deg_seq(*%w{:A3 3161 5131 3 1 :A2 7 :A3 1 :A3 3131
#                                3163 5131 3131 4121})

#        notes = deg_seq(*%w{:A3 1316 1513 1315 1312})
        #notes = deg_seq(*%w{:A3 4 :A2 7  :A3 1 :A2 7 })
        #notes = deg_seq(*%w{:A3 4363 5333 3331 3131})
        notes = deg_seq(*%w{:A3 21})

      with_fx :slicer, phase: bar do
      case notes[m_idx]
                    when note(:A3)
                      sample "/Users/josephwilk/Dropbox/repl-electric/samples/Bowed Notes/A_BowedGuitarNote_01_SP.wav", start: 0.2, amp: 0.2
                      sample "/Users/josephwilk/Dropbox/repl-electric/samples/Guitar Tails/108_A_PostRockChords_01_SP.wav", amp: 1.0
                    when note(:Fs4)
#                      sample "/Users/josephwilk/Dropbox/repl-electric/samples/Battery/Chords 80BPM Samples/am_chrd80_flights_F#m9.wav"
                      sample "/Users/josephwilk/Dropbox/repl-electric/samples/Bowed Notes/F#_BowedGuitarNote_01_SP.wav", start: 0.2, amp: 0.2
                    when note(:Cs4)
                      sample "/Users/josephwilk/Dropbox/repl-electric/samples/Guitar Tails/92_C#_PostRockChords_01_SP.wav", amp: 0.5
                    when note(:E4)
                      sample "/Users/josephwilk/Dropbox/repl-electric/samples/Bowed Notes/E_BowedGuitarNote_01_SP.wav", start: 0.2, amp: 0.5
#                      sample "/Users/josephwilk/Dropbox/repl-electric/samples/Guitar\ Tails/92_E_PostRockChords_01_SP.wav"
                    end
                  end
                  #3161 5131 2121 3132

        play notes[m_idx], amp: (notes[m_idx] == note(:Fs4)) ? 0.45 : 1, decay: 0.1 + rrand(0.0,0.15)
        if m_idx % 4 == 0 
                    with_synth :fm do
                      use_synth_defaults detune: 0.0, sustain_level: 0.20, res: 1, env_curve: 7 ,sustain: 1.0, attack: 0.01, decay: 0.15, amp: 1.0, release: 0.5, attack_level: 0.8, mod_phase: 2
                      play deg_seq(*%w{:A1 1 _ _ _ 
                                       :A1 8 _ _ _
                                       :A1 4 _ _ _ 
                                       :A1 5 _ _ _ 

                                       :A1 1 _ _ _
                                       :A1 6 _ _ _
                                           5 _ _ _ 
                                       :A2 2 _ _ _
                                           })[m_idx], decay: (ring bar*8, 0, 0, 0, 
                                                                   bar*8, 0, 0, 0)[m_idx],
                        amp: 1.0*(ring 0.8, 0, 0, 0,
                                       0.85, 0, 0, 0,
                                       0.8, 0, 0, 0,
                                       0.85, 0, 0, 0)[m_idx],  sustain: (bar/2.0) + rrand(0.0,0.1)
                    end;end

        #3161 5131 3131 3121
        if m_idx % 4 == 0 
                    with_fx :slicer, phase: (knit bar*4, 4, bar*6, 4)[m_idx] do
                    with_fx :lpf, cutoff: 80 do
                    with_synth :beep do
                      play deg_seq(*%w{:A2 5 _ _ _ 
                                       :A3 3 _ _ _
                                       :A2 1 _ _ _
                                       :A2 1 _ _ _

                                       :A2 5 _ _ _
                                       :A3 3 _ _ _
                                       :A2 1 _ _ _
                                       :A2 6 _ _ _
                                           })[m_idx], decay: bar*4, amp: 0.6, sustain: bar/2.0
                    end;end;end;end
        #if m_idx % 4 == 0 
#                    with_fx :slicer, phase: bar do
                    with_fx :lpf, cutoff: 60 do
                    with_synth :dark_ambience do
                      use_synth_defaults release: bar*2
                      play deg_seq(*%w{:A3 _ _ _ _ 
                                       :A3 _ _ _ _
                                       :A4 6 _ _ _
                                           _ _ _ _

                                       :A3 _ _ _ _
                                       :A3 _ _ _ _
                                       :A4 7 _ _ _
                                           _ _ _ _
                                          })[m_idx],detune2: 12, decay: bar*2, amp: 0.7, sustain: bar/2.0, attack: 0.5
                    #end
end;end;end;end;end;end
    with_fx :reverb, room: 1.0 do                
        with_synth :dark_ambience do
          if m_idx % 4 == 0
            #play chord((ring :Cs4, :E4, :Cs4, :Cs4)[m_idx], "7sus2")[(ring 0)[m_idx]], amp: 0.5, release: bar*2, decay: bar*2, attack: 1.0
end;end;end;end;
  m_idx+= 1
end
live_loop :dark_highlight do |n_idx|; with_fx :level, amp: 0.0 do
  _ = nil
    with_synth :dark_ambience do
      with_fx :reverb, room: 0.8 do

notes = (ring
              chord_degree(1, :a3, :major)[0..2],_,_,_,
              _,_,_,chord_degree(4, :a2, :major)[0],
              #
              chord_degree(1, :a4, :major)[0],chord_degree(1, :a3, :major)[0],_, chord_degree(4, :a2, :major)[0],
              _,_,_,chord_degree(4, :a2, :major)[0],
              #
              chord_degree(5, :a3, :major)[0],_,_,_,
              _,_,_,chord_degree(4, :a3, :major)[0],
        )
#comment do
        1.times{sync :whole}
  play notes[n_idx], release: (ring bar*4, bar*4, bar*4, bar*6)[n_idx], attack: 0.50,
          amp: (ring 1.0, 1.0, 1.0, 1.0, 1.5, 1.5, 1.5,1.5)[n_idx]
#end

with_synth :dark_sea_horn do
if notes[n_idx] == chord_degree(1, :a4, :major)[0]
play notes[n_idx], amp: 0.2, release: bar*4, attack: 0.1
end
end

comment do
        1.times{sync :whole}

        play (ring
              chord_degree(1, :a3, :major)[0..2],_,
              _,chord_degree(4, :a2, :major)[0],
              #
              chord_degree(1, :a4, :major)[0],chord_degree(1, :a3, :major)[0],
              _,chord_degree(4, :a2, :major)[0],
              #
              chord_degree(5, :a3, :major)[0],_,
              _,chord_degree(4, :a3, :major)[0],
        )[n_idx], release: (ring bar*4, bar*4, bar*4, bar*6)[n_idx], attack: 0.28,
          amp: (ring 1.0, 1.0, 1.0, 1.0, 1.5, 1.5, 1.5,1.5)[n_idx]
end

comment do
        1.times{sync :quarter}
      with_fx :lpf, cutoff: 100, mix: 1.0 do

        play (ring                  
#              chord_degree(1, :a4, :major)[0], chord_degree(1, :a3, :major)[1], chord_degree(1, :a3, :major)[1], chord_degree(1, :a3, :major)[0],
 #             chord_degree(3, :a4, :major)[0], chord_degree(3, :a3, :major)[1], chord_degree(3, :a3, :major)[2], chord_degree(1, :a3, :major)[0],
              _, _, _, chord(:a3, :sus2),
              _, _, _, chord(:a3, :sus2)[0],
              _, _, _, degree(3, :a3, :major),
              _, _, _, degree(3, :a3, :major)

#wholes :A3 3    161 5131 3131 3131}
#              chord_degree(7, :a2, :major)[0], chord_degree(7, :a2, :major)[1], chord_degree(7, :a2, :major)[2], _
)[n_idx], release: (ring bar*2, bar, bar, bar*2)[n_idx], attack: (ring 1.0, 0.5, 0.5, 0.5)[n_idx],
          amp: (ring 1.2, 1.0, 1.1, 0.9)[n_idx]
end
end
      end
    end
  end
  n_idx+=1
end

live_loop :crackler do;with_fx :level, amp: 0.2 do
crack_dur = sample_duration(ambi_s(:crackling))
a = 0.5
sync :whole
s = sample ambi_s(:crackling), amp: a, rate: 0.1
4.times{|n| sleep crack_dur/4.0;
s = sample ambi_s(:crackling), amp: a, rate: (n*0.2) 
}
end;end;

@brightlight_amp = 0.0
@piano_amp = 0.0
