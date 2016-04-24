set_volume! 0.9
_=nil
use_bpm 60
live_loop :bazz, sync: :thing do
  sleep 4
end
live_loop :second_voice, sync: :thing do
  with_fx :distortion, mix: 0.7 do
    with_fx :wobble, phase: 16, invert_wave: 0  do
      with_fx :slicer, phase: 0.25, probability: 0.5  do
        synth :dark_ambience, note: chord(:E6, :M7), amp: 1, decay: 8
      end
    end
  end
  sleep 16
end
live_loop :fourth_voice, sync: :thing do
  sleep 4
  4.times{
    synth :plucked, note: (ring :E3, :E4).tick(:d), amp: 0.5, decay: 0.25, pan: [0.25,-0.25].choose
    sleep 1/2.0/2.0
  }
end

live_loop :third_voice, sync: :thing do
  n = (knit chord(:Fs1, :m), 2, chord(:E1, :M),1, chord(:B1, :m), 1, chord(:E2, :M), 1)
  with_transpose 0 do
    synth :dsaw, cutoff: 60, note: n.tick[0], amp: 0.6, decay: (ring 0.25, 0.25, 0.25/2.0, 0.25).tick(:D)*4, attack: 0.01
    synth :prophet, cutoff: 60, note: n.tick[-1], amp: 0.6, decay: (ring 0.25, 0.25, 0.25/2.0, 0.25).tick(:D)*4, attack: 0.01
  end
  sleep 2
end

with_fx(:reverb, room: 0.9, mix: 0.4, damp: 0.5) do |r_fx|
  live_loop :hollower, sync: :thing do
    with_transpose (knit 0,3, 7.0,0).tick(:t) do
      d = (ring
           #[:fs4, 1], [:fs3, 0.5],[_, 0.5], [:A3, 0.5], [:fs3, 1.0], [:Cs3, 0.5]
           [:e3, 1], [:e3, 0.5],[_, 0.5], [:A3, 0.5], [:e3, 1.0], [:Cs3, 0.5],
           [:e3, 1], [:e3, 0.5],[_, 0.5], [:A3, 0.5], [:e3, 1.0], [:Cs3, 0.5],
           [:e3, 1], [:e3, 0.5],[_, 0.5], [:A3, 0.5], [:e3, 1.0], [_, 0.5],
           [:e3, 1], [:e3, 0.5],[_, 0.5], [:B3, 0.5], [:gs3, 1.0], [:Cs3, 0.5],
           
           [:e3, 1], [:e3, 0.5],[_, 0.5], [:A3, 0.5], [:e3, 1.0], [:Cs3, 0.5],
           [:e3, 1], [:e3, 0.5],[_, 0.5], [:A3, 0.5], [:e3, 1.0], [:Cs3, 0.5],
           [:e3, 1], [:e3, 0.5],[_, 0.5], [:A3, 0.5], [:e3, 1.0], [_, 0.5],
           [:e3, 1], [:e3, 0.5],[_, 0.5], [:B3, 0.5], [:gs3, 1.0], [:Cs3, 0.5],
           
           [:e3, 1], [:e3, 0.5],[_, 0.5], [:A3, 0.5], [:e3, 1.0], [:Cs3, 0.5],
           [:e3, 1], [:e3, 0.5],[_, 0.5], [:A3, 0.5], [:e3, 1.0], [:Cs3, 0.5],
           [:e3, 1], [:e3, 0.5],[_, 0.5], [:A3, 0.5], [:e3, 1.0], [_, 0.5],
           [:e3, 1], [:e3, 0.5],[_, 0.5], [:B3, 0.5], [:gs3, 1.0], [:Cs3, 0.5],
           
           [:e3, 1], [:gs3, 0.5],[_, 0.5],[:B3, 0.5],[:B3, 1.0], [:Cs3, 0.5],
           [:e3, 1], [:e3, 0.5],[_, 0.5], [:Cs4, 0.5],[:e3, 1.0], [:Cs3, 0.5],
           [:e3, 1], [:gs3, 0.5],[_, 0.5],[:B3, 0.5],[:e3, 1.0], [_, 0.5],
           [:fs3, 1],[:e3, 0.5],[_, 0.5], [_, 0.5],   [:gs3, 1.0], [:Cs3, 0.5],
           
           ).tick(:n)
      d[1] = d[1]/4.0

      d2 = (ring #7 per ring   2   2
           [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
           [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
           [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
           [:e3, 1], [:cs4, 0.5],[_, 0.5], [_, 0.5],   [:gs3, 1.0], [:Cs3, 0.5],

           [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
           [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
           [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
           [:e3, 1], [:cs4, 0.5],[_, 0.5], [_, 0.5],   [:gs3, 1.0], [:Cs3, 0.5],

           [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
           [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
           [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
           [:e3, 1], [:cs4, 0.5],[_, 0.5], [_, 0.5],   [:gs3, 1.0], [:Cs3, 0.5],

          [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
           [_, 1],  [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
           [_, 1],  [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
           [:e3, 1],[:cs4, 0.5],[_, 0.5], [_, 0.5], [:fs3, 1.0], [:Cs3, 0.5],
           ).tick(:n2)
        with_fx :echo, phase: 1, decay: 2.0, mix: 0 do
        with_transpose 12 do
          synth :hollow, note: d2[0], amp: 6.0, decay: d2[1]/8
      
      synth :hollow, note: (knit
                            _,16, :e3, 1, _, 7,
                            _,16, :gs3, 1, _, 7,
                            _,16, :e3, 1, _, 7,
                            _,16, :e3, 1, _, 7).tick(:d), amp: 5.0*0, decay: 1.0
      
    end
  end
  
  with_fx :distortion, mix: 0.8 do
    if d[0] == [:fs4]
      n = synth :gpa ,note: d[0],  amp: 1.0*1, release: d[1], note_slide: 0.25,attack: 0.0001, cutoff: 80
      control n, note: :Fs4
    else
      #n = synth :gpa, note: d[0],  amp: 1.9, release: d[1]*2, attack: 0.0001, wave: 6
      n = synth :gpa, note: d[0],  amp: 0.9, release: d[1]*2, attack: 0.0001, wave: 4, cutoff: (ramp *(range 0,135, 1)).tick(:r4)
    end
    synth :hollow, note: (ring
                          _, _, _, _,
                          _, _, _, _,
                          _, _, _, _,
                          :Cs4, :E5, :FS3, :FS3,
                          :Cs4, :E5, :CS5, :CS4,
                          :Cs4, :E5, :FS4, :FS4,
                          
                          :Cs4, :E5, :FS3, :FS3,
                          :Cs4, :E5, :CS5, :CS4,
                          :Cs4, :E5, :GS3, :GS3,
                          
                          
    ).tick(:n2), amp: 0.0, release: d[1]/4.0, cutoff: (range 80,100, 5).tick(:c)
    end
    _=:r
    synth :blade, note: (ring
                         [:gs4,:Fs4,:Cs4,:E4].choose, _, _, _,
                         _, _, _, _,
                         _, _, _, _,
                         _, _, _, _,
                         _, _, _, _,
                         _, _, _, _,
                         ).tick(:n3), amp: 0.5, release: d[1], cutoff: (range 80,100, 5).tick(:c2)
    sleep d[1]
  end
end
end

with_fx :reverb do
  live_loop :thing do
    _=nil
    l = (ring 1.0, 0.5, 0.5, 0.5, 0.5, 1.0, 0.5).tick/4.0
    n = (ring
         :fs3, :e2, :gs3#,  :fs2, :e2, :Gs4, :fs3
         ).tick(:note)
    n2 = (ring
          _, _, _,_, _, _,
          _, _, _,_, _, _,
          _, _, _,_, _, _,
          _, _, _,:FS4, _, _,
          ).tick(:note2)
    with_transpose [5,0].choose do
      # synth :hollow, note: n2, release: 1.0, amp: 4.0*1
    end
    
    with_fx :distortion, mix: 0.2, distort: (range 0.1, 0.7, 0.1).tick(:r) do
      with_fx :bitcrusher, bits: (range 4,16,1).tick(:b), mix: 0.2 do
        #  synth :dsaw, note: n, release: l, cutoff: (rrand 80,90), amp: 0.6*0.9
      end
    end
    #synth :tri, note: n, release: l, amp: 1 *1
    #synth :gpa, note: n, release: l*2, amp: 1 *1
    sleep l
  end
end


live_loop :beat, sync: :thing do
  sample Fraz[/kick/,[2,2]].tick(:sample), cutoff: 130, amp: 2.0
  sleep 1/2.0/2.0
  sample Fraz[/kick/,[2,2,2,2]].tick(:sample), cutoff: 120, amp: 1.9
  sleep 1/2.0/2.0
  # sample Fraz[/kick/,[2,2,2,2]].tick(:sample), cutoff: 130, amp: 0.8
  #  sample Ether[/snare/,[0,0]].tick(:sample), cutoff: 135, amp: 1.0
  sleep 1/2.0
  3.times{
    sample Fraz[/kick/,[2,2]].tick(:sample), cutoff: 120, amp: 1.0
    sleep 1/2.0
    #sample Fraz[/kick/,[2,2,2,2]].tick(:sample), cutoff: 130, amp: 0.8
    #sample Ether[/snare/,[0,0]].tick(:sample), cutoff: 135, amp: 1.0
    sleep 1/2.0
  }
end

live_loop :voice2, sync: :thing do
  n = (ring :Fs1, :A1, :Cs1, :D2, :E1).tick(:c)
  cue :fire if n == :Cs1 || n == :D2 || n == :E1
  with_fx :slicer, phase: 0.25, wave: 0 do
    #sample Ether[/noise/,[0,0]].tick(:sample), cutoff: 130, amp: 0.2
    #synth :dark_sea_horn, note: (ring :Fs2, :A1, :Cs2, :D2, :E2).look(:c), decay: 4.5, attack: 0.001, amp: 2.0
  end
  with_fx :slicer, phase: 0.25, invert_wave: 1, wave: 0 do
  end
  sleep 4.0
end

live_loop :perc, sync: :thing do
  tick
  #sample CineElec[/extra/, /glass/].tick(:s), amp: 1.0, start: 0.21, finish: 0.27
  if (ring 0,1,0,0).look == 1
    sample CineElec[/Percussions/,/Pepper/, [0,1]].tick(:sample), amp: 0.5+rand*0.1
  end
  #if (ring 0,0,1,0, 0,0,0,0,  0,1,1,0, 0,0,0,0,  0,0,1,0,0,0,0,1,   0,1,1,0, 0,0,1,0).look == 1
  if (ring
      0,0,1,0, 0,0,1,0,  0,0,1,0, 0,1,0,1,
      0,1,0,0, 0,1,0,0,  0,1,0,0, 0,1,0,1,).look == 1
    #sample Words[/beauty/,[3,3]].tick(:s), amp: 8.0, start: 0.1, finish: 0.11 + [0.04,0.0].choose
    with_fx :lpf, cutoff: 80 do
      sample CineElec[/one shots/,/hat/,[10,10,3,10]].look, amp: 1.5, start: 0.0
    end
  end
  if (ring
      0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
      0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0).look == 1
    #sample Abstract[/one shots/,/layered/, /open/,0], amp: 1.5, start: 0.0
    p = (ring [rand*0.25,rand*0.5]).tick(:pos)
    with_fx :echo, feedback: rand*0.5, phase: 0.5, decay: 8, mix: [1.0,0.0].choose do
      sample(Words[/beauty/,[3,3]].tick(:s), amp: 2.0, start: p[0], finish: p[1])
      #sample Frag[/coil/,/f#m/,4], amp: 1.55
    end
  end
  sleep 0.25
end

live_loop :voice4, sync: :voice2 do
  sync :fire
  #sample(Words[/beauty/,[3,3]].tick(:s), amp: 2.0)
  
  8.times{
    sleep 0.25
    sample Ether[/noise/,[0,0]].tick(:sample), cutoff: 130, amp: 0.1
  }
end
