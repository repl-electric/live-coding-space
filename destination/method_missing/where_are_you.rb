["instruments","shaderview","experiments", "log","samples"].each{|f| require "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}; _=nil
set_volume! 0.1

live_loop :bazz, sync: :thing do
  _=[[], 0.125]
  b = (ring  #1.75       0.875 per line         # 0.4375
       [chord(:A2, :M, invert: 0),   1.0],      [[], 0.5], [[:Cs2], 0.5], #0.5+0.125
       [chord(:Cs3, :m),              1.0],     [[], 0.5], [[:A1], 0.5],
       [chord(:A2,  :M),             0.75],     [[], 1.0], [[:B1], 0.25],
       [chord(:Fs2, :m,  invert: 3), 0.75],     [[], 1.0], [[], 0.25]
       ).tick(:n2)
  puts note_inspect(b[0])
  with_transpose 0 do
    #if b[0].length > 1
    synth :fm, note: b[0][0], amp: 1.0, decay: b[1]*1 , attack: 0.001
    #end
    if b[0].length == 1
      #synth :dark_sea_horn, note: b[0][0], amp: 1.0, decay: 8*b[1] , attack: 0.001
    end
    synth :tb303, note: b[0], amp: 2.0, decay: b[1] , attack: 0.001, cutoff: 60
    with_transpose -12 do
      with_fx(:slicer, phase: 0.25, probability: 0, invert_wave: 1) do
        # synth :dsaw, note: b[0], amp: 2.0, decay: b[1]*4 , attack: 0.001, cutoff: 65
      end
      with_fx(:slicer, phase: 0.25, probability: 0, invert_wave: 0) do
        # synth :dsaw, note: b[0], amp: 2.0, decay: b[1]*4 , attack: 0.001, cutoff: 65
      end
      ##      synth :tb303, note: b[0], amp: 4.0, decay: b[1] , attack: 0.001, cutoff: 60
      #synth :tb303, note: b[0].map{|n| n - 12}, amp: 1.0, decay: b[1] , attack: 0.001, cutoff: 65
      #synth :tb303, note: b[0][2], amp: 1.0, decay: b[1] , attack: 0.001, cutoff: 65
      #synth :beep, note: b[0].map{|c|c-12}, amp: 1.2, decay: b[1] , attack: 0.001
    end
  end
  with_transpose -12 do
    #   synth :prophet, note: b[0][0], amp: 0.3, decay: b[1]*4, attack: 0.001, cutoff: 60
    #   synth :dsaw,    note: b[0][0], amp: 0.3, decay: b[1]*4, attack: 0.001, cutoff: 60
  end
  sleep b[1]
end

with_fx(:reverb, room: 0.9, mix: 0.4, damp: 0.5) do |r_fx|
live_loop :hollower, sync: :thing do
  with_transpose 0 do
    d = (ring #7 per ring   2   2
         #     [:fs4, 1], [:fs3, 0.5],[_, 0.5], [:A3, 0.5], [:fs3, 1.0], [:Cs3, 0.5]
         [:gs3, 1], [:gs3, 0.5],[_, 0.5], [:A3, 0.5], [:gs3, 1.0], [:Cs3, 0.5],
         [:gs3, 1], [:gs3, 0.5],[_, 0.5], [:A3, 0.5], [:gs3, 1.0], [:Cs3, 0.5],
         [:gs3, 1], [:gs3, 0.5],[_, 0.5], [:A3, 0.5], [:gs3, 1.0], [:Cs3, 0.5],
         [:fs3, 1], [:gs3, 0.5],[_, 0.5], [:A3, 0.5], [:gs3, 1.0], [:Cs3, 0.5],
         ).tick(:n)
    # d = (ring  [:fs4, 1], [:gs3, 0.5], [_, 0.5], [:A3, 0.5], [:gs3, 1.0], [:Cs3, 0.5]).tick
    d[1] = d[1]/4.0

    #sample (ring Frag[/coil/, /f#/, 2], nil).tick(:s), rate: 2.0, amp: 8.0 if d[0] == :fs4
    #sample Ether[/noise/,[1,1,1]].tick(:sample), cutoff: 120, amp: 0.5

    with_fx :distortion do
      if d[0] == [:fs4]
        #n = synth :gpa ,note: d[0],  amp: 8.0*1, release: d[1], note_slide: 0.25,attack: 0.0001, cutoff: 80
        #control n, note: d[0]
        #n = synth :plucked, note: (knit :f4,1,_,3).tick(:sour),  amp: 0.5*1, release: d[1]*4, note_slide: 0.25,attack: 0.0001
      else
        with_transpose 0 do
          n = synth :gpa, note: d[0],  amp: 0.6*8, release: d[1], attack: 0.0001, cutoff: 80
        end
      end
      synth :hollow, note: (ring
                            _, _, _, _,
                            _, _, _, _,
                            _, _, _, _,
                            :Cs4, :E5, :FS3, :FS3,
                            :Cs4, :E5, :CS4, :CS4,
                            :Cs4, :E5, :FS3, :FS3,
      ).tick(:n2), amp: 8.5*3, release: d[1]/4.0, cutoff: (range 80,100, 5).tick(:c)
    end
      _=:r
      synth :blade, note: (ring
                            [:gs4,:Fs4,:Cs4,:E4].choose, _, _, _,
                            _, _, _, _,
                            _, _, _, _,
                            _, _, _, _,
                            _, _, _, _,
                            _, _, _, _,
      ).tick(:n3), amp: 2.5*2, release: d[1], cutoff: (range 80,100, 5).tick(:c2)
      sleep d[1]
    end
  end
end

with_fx :reverb do
  live_loop :thing do
    _=nil
    l = (ring 1.0, 0.5, 0.5, 0.5, 0.5, 1.0, 0.5).tick/4.0
      n = (ring
           :fs3 #:e2, :gs3 #, :fs2, :e2# :Gs4, :fs3
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
          #synth :dsaw, note: n, release: l, cutoff: (rrand 80,90), amp: 0.6*0.4
        end
      end
      #    synth :tri, note: n, release: l, amp: 1 *1
      #    synth :gpa, note: n, release: l*2, amp: 1 *1
      sleep l
    end
  end

  live_loop :beat, sync: :thing do
    florish = spread(1,8, rotate: 0).tick(:flo)
    if florish
      sample Fraz[/kick/,[2,3]].tick(:sample), cutoff: 100, amp: 1.0
      # sample Ether[/snare/,[3,3]].tick(:sample), cutoff: 110, amp: 1.0
      sleep 1/2.0/2.0
      sample Fraz[/kick/,[2,4,4,4]].tick(:sample), cutoff: 120, amp: 1.0
      sleep 1/2.0/2.0
      sample Frag[/kick/,[4,5]].tick(:sample), cutoff: 130, amp: 1.0 if dice(6) > 3
      sample Ether[/snare/,[2,2]].tick(:sample), cutoff: 135, amp: 1.0
      sleep 1/2.0
    else
      sample Fraz[/kick/,[1,0,0,0]].tick(:sample), cutoff: 100+rand, amp: 1.0
      sleep 1/2.0
      sample Frag[/kick/,[1,0]].tick(:sample), cutoff: 100+rand, amp: 1.0
      with_fx :echo, phase: 0.25/2.0, mix: 0 do
        sample Ether[/snare/,[0,0]].tick(:sample), cutoff: 135, amp: 1.0
      end
      sleep 1/2.0
    end
  end
  
live_loop :beat, sync: :thing do
    florish = spread(1,8, rotate: 0).tick(:flo)
    sample Fraz[/kick/,[1,0,0,0]].tick(:sample), amp: 10.0, cutoff: 135
    sleep 1.0/2.0
    sample Frag[/kick/,[1,0]].tick(:sample), amp: 1.0, cutoff: 80
    #   with_fx(:reverb, room: 0.3, mix: 0.4, damp: 0.5) do |r_fx|
    with_fx :slicer, phase: (ring 0.5, 1.0, 1.0, 0.25).tick(:pahse)/1.0, mix: 0.5 do
    with_fx :echo, phase: 0.25/2.0, mix: 0.0 do
      sample Ether[/snare/,[0,0]].tick(:sample), cutoff: 100, amp: 2.0
    end
  end
  #  end
  sleep 1/2.0
end


  live_loop :voice2, sync: :thing do
    n = (ring :Fs1, :A1, :Cs1, :D2, :E1).tick(:c)

    cue :fire if n == :Cs1 || n == :D2 || n == :E1

    with_fx :slicer, phase: 0.25, wave: 0 do
      #  sample Ether[/noise/,[0,0]].tick(:sample), cutoff: 130, amp: 0.2
      #synth :dark_sea_horn, note: (ring :Fs2, :A1, :Cs2, :D2, :E2).look(:c), decay: 4.5, attack: 0.001, amp: 2.0
    end
    with_fx :slicer, phase: 0.25, invert_wave: 1, wave: 0 do
      #synth :dark_sea_horn, note: (ring :Fs1, :A1, :Cs1, :D2, :E1).look(:c), decay: 4.5, attack: 0.001, amp: 2.0
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

  live_loop :hats, sync: :thing do
    sleep 0.25
    if spread(7,11).tick
      sample Dust[/hat/,[0,0,0,1]].tick(:sample), cutoff: 85+rand, amp: 0.9, start: rrand(0.0,0.05)
    end
    if spread(3,7).look
      sample Dust[/hat/,[1,2]].tick(:sample2), cutoff: 85+rand, amp: 0.9, start: rrand(0.0,0.05)
    end
    if spread(1,16).look
      sample Dust[/hat/,/open/,0..1].tick(:sample3), cutoff: 85+rand, amp: 0.9, start: rrand(0.0,0.05)
    end
  end

  live_loop :corruption, sync: :thing do
    sample Corrupt[/#/,[0,0]].tick(:sample), amp: 1.0
    sleep 4
  end

  live_loop :apeg, sync: :thing do
    with_fx (ring :none,:none, :none, :echo).tick, phase: 0.25/2, decay: 2 do
      sample Mountain[/microperc/,[6,6,6,7]].tick(:sample1), cutoff: 130, amp: 1.5
    end
    sleep 1/2.0
    sample Mountain[/microperc/,[6,6]].tick(:sample2), cutoff: 130, amp: 1.5
    sleep 1/2.0
  end
