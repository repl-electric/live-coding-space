["instruments","shaderview","experiments", "log","samples"].each{|f| require "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}; _=nil
set_volume! 0.5

live_loop :bazz, sync: :thing do
  _=[[], 0.125]
  b = (ring
       [chord(:Gs2, :m),   0.5],             _,_, [[:Cs2], 0.125],
       [chord(:Cs3, :m),   0.5],             _,_, [[:A1], 0.125],
       [chord(:A2,  :M),   0.875-0.125],          [[:B1], 0.125],
       [chord(:Gs2, :m, invert: 1), 0.75],  [[], 0.125],

       ).tick(:n2)
  with_transpose 0 do
    if b[0].length == 1
      synth :fm, note: b[0][0], amp: 4.0, decay: b[1]*4 , attack: 0.001
    end
    synth :dark_sea_horn, note: b[0][0], amp: 4.9, decay: b[1]*4 , attack: 0.001
    with_fx(:slicer, phase: 0.5, probability: 0, invert_wave: 1) do
      synth :dsaw, note: b[0], amp: 2.9, decay: b[1]*4 , attack: 0.001
    end
    with_fx(:slicer, phase: 0.5, probability: 0, invert_wave: 0) do
      synth :dsaw, note: b[0].map{|c|c-12}, amp: 2.9, decay: b[1]*4 , attack: 0.001
    end
  end
  with_transpose -12 do
    synth :prophet, note: b[0][0], amp: 0.3, decay: b[1]*4, attack: 0.001, cutoff: 60
    synth :dsaw,    note: b[0][0], amp: 0.3, decay: b[1]*4, attack: 0.001, cutoff: 60
  end
  sleep b[1]*4
end

live_loop :hollower, sync: :thing do
  with_transpose 0 do
    d = (ring
         [:gs3, 1], [:gs3, 0.5], [:A3, 0.5], [:gs3, 1.0], [:Cs3, 0.5],        #2nd(G A C)  G B  D    F A C
         [:gs3, 1], [:gs3, 0.5], [:A3, 0.5], [:gs3, 1.0], [:Cs3, 0.5],
         [:gs3, 1], [:gs3, 0.5], [:A3, 0.5], [:gs3, 1.0], [:Cs3, 0.5],
         [:fs4, 1], [:gs3, 0.5], [:A3, 0.5], [:gs3, 1.0], [:Cs3, 0.5]
         ).tick(:n)
    d[1] = d[1]/4.0

    with_fx(:reverb, room: 0.9, mix: 0.4, damp: 0.5) do |r_fx|
      #sample (ring Frag[/coil/, /f#/, 2], nil).tick(:s), rate: 2.0, amp: 8.0 if d[0] == :fs4
  end

  #  sample Ether[/noise/,[1,1,1]].tick(:sample), cutoff: 120, amp: 0.5

  with_fx :distortion, mix: 0.1 do
    if d == [:fs4, 1/4.0]
      n = synth :gpa ,note: d[0],  amp: 8.0*4, release: d[1], note_slide: 0.25,attack: 0.0001, cutoff: 80
      control n, note: d[0]
    else
      with_transpose 0 do

        n = synth :gpa, note: d[0],  amp: 8.0*15, release: d[1], attack: 0.0001, cutoff: 130
      end
    end
    synth :hollow, note: (ring
                          _, _, _, _,
                          _, _, _, _,
                          _, _, _, _,
                          :Cs4, :E5, :FS3, :FS3,
                          :Cs4, :E5, :CS4, :CS4,
                          :Cs4, :E5, :FS3, :FS3,
    ).tick(:n2), amp: 8.5*0, release: d[1]/4.0, cutoff: (range 80,100, 5).tick(:c)
end
sleep d[1]
end
  end

with_fx :reverb do
  live_loop :thing do
    _=nil
    l = (ring 1.0, 0.5, 0.5, 0.5, 0.5, 1.0, 0.5).tick/4.0
    n = (ring
         :e3,_,_,_# :Gs4, :fs3
         ).tick(:note)
    n2 = (ring
          _, _, _,_, _, _,
          _, _, _,_, _, _,
          _, _, _,_, _, _,
          _, _, _,:FS4, _, _,
          ).tick(:note2)
    with_transpose [5,0].choose do
      synth :hollow, note: n2, release: 1.0, amp: 4.0*1
    end

    with_fx :distortion, mix: 0.2, distort: (range 0.1, 0.7, 0.1).tick(:r) do
      with_fx :bitcrusher, bits: (range 4,16,1).tick(:b), mix: 0.2 do
        synth :dsaw, note: n, release: l, cutoff: (rrand 80,90), amp: 0.6*0
      end
    end
    #    synth :tri, note: n, release: l, amp: 1 *1
    #    synth :gpa, note: n, release: l*2, amp: 1 *1
    sleep l
  end
end

live_loop :voice2, sync: :thing do
  n = (ring :Fs1, :A1, :Cs1, :D2, :E1).tick(:c)

  cue :fire if n == :Cs1 || n == :D2 || n == :E1

  with_fx :slicer, phase: 0.25, wave: 0 do
    #  sample Ether[/noise/,[0,0]].tick(:sample), cutoff: 130, amp: 0.2
    #    synth :dark_sea_horn, note: (ring :Fs2, :A1, :Cs2, :D2, :E2).look(:c), decay: 4.5, attack: 0.001, amp: 2.0
  end
  with_fx :slicer, phase: 0.25, invert_wave: 1, wave: 0 do
    #   synth :dark_sea_horn, note: (ring :Fs1, :A1, :Cs1, :D2, :E1).look(:c), decay: 4.5, attack: 0.001, amp: 2.0
  end
  sleep 4.0
end

live_loop :voice4, sync: :voice2 do
  sync :fire
  8.times{
    sleep 0.25
    sample Ether[/noise/,[0,0]].tick(:sample), cutoff: 130, amp: 0.1
  }
end

live_loop :hats do
  sleep 0.25
  if spread(7,11).tick
    sample Dust[/hat/,[0,0,0,1]].tick(:sample), cutoff: 85+rand, amp: 0.9, start: rrand(0.0,0.05)
  end
  if spread(3,7).look
    sample Dust[/hat/,[1,2]].tick(:sample2), cutoff: 85+rand, amp: 0.9, start: rrand(0.0,0.05)
  end
  if spread(1,16).look
    sample Dust[/hat/,/open/].tick(:sample3), cutoff: 85+rand, amp: 0.9, start: rrand(0.0,0.05)
  end
end

live_loop :beat, sync: :thing do
    sample Fraz[/kick/,[1,0,0,0]].tick(:sample), cutoff: 100, amp: 1.0
    sleep 1/2.0
    sample Frag[/kick/,[1,0]].tick(:sample), cutoff: 100, amp: 1.0

    with_fx :echo, phase: 0.25/2.0, mix: 0.0 do
      sample Ether[/snare/,[0,0]].tick(:sample), cutoff: 135, amp: 1.0
    end
    sleep 1/2.0
end
