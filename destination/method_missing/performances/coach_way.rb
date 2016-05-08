set_volume! 0.9
_=nil
use_bpm 60
live_loop :thing do
  sleep 4
end
with_fx :wobble, phase: 16 do
  live_loop :third_voice, sync: :thing do
    tick
    n = (ring
         #       [chord(:Fs3, :m),2], [chord(:Fs3, :m),2],
         #      [chord(:E3, :M),2],
         #     [chord(:D3, :M),2],
         #    [chord(:Gs3, :dim),1],
         #   [chord(:D3, :m),2]
         [chord(:a2, :M), 4],
         [chord(:cs3, :m),2],
         [chord(:a2, :M),2],
         [chord(:e3, :M),2],
         [chord(:d3, :M),2],[chord(:d3, :M),2],
         [chord(:e3, :M),2],
         [chord(:Fs3, :m),2],[chord(:Fs3, :m, invert: -1),2]
         )
    synth :dark_sea_horn, note: n.tick[0], amp: 1.0, decay: (ring 0.25, 0.25, 0.25/2.0, 0.25).tick(:D)*4, attack: 0.01
    #synth :gpa, note: n.look[0], release: n.look[-1], wave: 6, amp: 8
    #synth :dark_ambience, note: chord(:E5, :M7), amp: 2, decay: 8
    puts note_inspect(n.look[0])
    sleep n.look[-1]
  end
end
live_loop :second_voice, sync: :thing do
  with_fx :distortion, mix: 0.7 do
    rand_reset
    p = [0.25, 0.5]
    with_fx :wobble, phase: 16, invert_wave: 0  do
      with_fx :slicer, phase: p[0], probability: 0.5  do
        #synth :dark_sea_horn, note: chord(:E3, :M7)[0], amp: 1, decay: 4
        #synth :dark_ambience, note: chord(:E5, :M7), amp: 2, decay: 8
      end
      with_fx :slicer, phase: 0.25, probability: 0.5, invert_wave: 1  do
        #synth :dark_sea_horn, note: chord(:Fs2, :m11)[0], amp: 2, decay: 4
        #synth :dark_ambience, note: chord(:Fs6, :m11), amp: 2, decay: 8
      end
      with_fx :slicer, phase: p[1], probability: 0.5, invert_wave: 1  do
        #synth :dark_sea_horn, note: chord(:D3, :M7)[0], amp: 1, decay: 4
        #synth :dark_ambience, note: chord(:D5, :M7), amp: 2, decay: 4
      end
    end
  end
  sleep 16
end

with_fx(:reverb, room: 0.9, mix: 0.3, damp: 0.5) do |r_fx|
  live_loop :hollower, sync: :thing do
    with_transpose (knit  7.0,0,0,3).rotate(0).tick(:t) do
      d = (ring
           [:D4, 0.125],[_, 0.125],[:D4, 0.125],[_, 0.125],[:D4, 0.125],[_, 0.125],[:D4,0.25], [_,0.25],
           [:D4,0.5], [:E4, 0.25], [_, 0.125], [:E4,0.5], [_,0.5], [:E4,0.25], [_, 0.5],[:E4,0.25],
           [_, 0.5], [:E4,0.25], [_, 0.5], [_,0.5+0.5]).rotate(0).tick(:n)
      d[1] = d[1]/4.0
      d4 = (knit [:e3, 1.0],1, [_, 0.5], 23,
            [:e3, 1.0],1, [_, 0.5], 23,
            [:e3, 1.0],1, [_, 0.5], 23,
            [:gs3, 1.0],1, [_, 0.5], 23
            ).rotate(3).tick(:v3)
       #synth :growl, note: d4[0], amp: 4.0, release: d4[1]*2
      score = (ring #7 per ring   2   2
            [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [:fs3, 1], [:cs3, 0.5],[_, 0.5], [_, 0.5],   [:a3, 1.0], [:e3, 0.5],   #  E3 G#3   B3    C#4

            [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [:e3, 1], [:cs3, 0.5],[_, 0.5], [_, 0.5],   [:a3, 1.0], [:e3, 0.5],   #C# E

            [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [:e3, 1], [:cs3, 0.5],[_, 0.5], [_, 0.5],   [:a3, 1.0], [:e3, 0.5],

            [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [_, 1],  [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [_, 1],  [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [:e3, 1],[:cs3, 0.5],[_, 0.5], [_, 0.5], [:fs3, 1.0], [:e3, 0.5],
            )
      d2 = score.tick(:n2)
      with_fx (ring :echo, :reverb, :echo, :echo).tick(:fx), phase: 1/1.0, decay: 2.0, mix: 0.0 do |fx|
        control fx, damp: rand
        with_transpose 12 do
          h = synth :hollow, note: d2[0], amp: 4.0*1, decay: d2[1]/8.0, note_slide: 0.125
          synth :hollow, note: (knit
                                _,16, :e3, 1, _, 7,
                                _,16, :gs3, 1, _, 7,
                                _,16, :e3, 1, _, 7,
                                _,16, :e3, 1, _, 7).tick(:d), amp: 2.0*1, decay: 1.0
        end
      end
      if look(:n) % 20 > 10
        with_fx :echo, decay: 2, phase: 0.25 do
          synth :pretty_bell, note: d[0], amp: 0.3
        end
      end
      with_fx :distortion, mix: 0.2 do
        if d[0] == [:fs4]
          n = synth :gpa ,note: d[0],  amp: 1.0*1, release: d[1], note_slide: 0.25,attack: 0.0001, cutoff: 80
          control n, note: :Fs4
        else
          n = synth :beep, note: d[0],  amp: 1.0, release: (d[1]*4)+1, attack: 0.0001, wave: 2
          #n = synth :dark_sea_horn, note: d[0],  amp: 4.0, release: d[1]*2, attack: 0.0001, wave: 4, cutoff: 135
        end
        sleep d[1]*4
      end
    end
  end
end

live_loop :moo, sync: :thing do
  synth :gpa, note: (knit :FS3, 31, :D4,1,  :FS3, 31, :E4,1).tick, amp: 2.8, attack: 0.001, release: 0.25
  sleep 0.25
end

live_loop :beat, sync: :thing do
  tick
  main_d = Mountain[/subkick/,[1,1]]#
          6.times{
            if spread(1,2).tick(:m)
              sample MagicDust[/click/,9], cutoff: 110, amp: 2.0+rand
            end
            sample main_d.look, cutoff: 120, amp: 4.0+rand
            sleep 1/2.0/2.0
            sleep 1/2.0/2.0
            # sleep 1/2.0
          }
          sample Mountain[/ice/,[2,3]].tick(:sample), cutoff: 120, amp: 1.0
          sample main_d.look, cutoff: 110, amp: 4.0
          #    sleep 1/2.0/2.0
          #   sleep 1/2.0/2.0
          sleep 1/2.0/2.0
          sample Mountain[/ice/,[3,4]].tick(:sample), cutoff: 120, amp: 1.0
          sample main_d.look, cutoff: 135, amp: 4.0
          sleep 1/2.0/2.0
          #sample main_d, cutoff: 135, amp: 4.0
          
          comment do
            2.times{
              sample Fraz[/kick/,[2,2]].tick(:sample), cutoff: 100, amp: 1.0
              #  sleep 1/2.0
              sleep 1/2.0
            }
            #     sample Fraz[/kick/,[2,2]].tick(:sample), cutoff: 100, amp: 1.0
            #      sample Ether[/snare/,[0,0]].tick(:sample), cutoff: 135, amp: 1.0
            #     sleep 1/2.0
            #sleep  1/2.0/2.0
            #    sample Fraz[/kick/,[2,2]].tick(:sample), cutoff: 130, amp: 1.5
            #sleep 1/2.0/2.0
          end
        end
        
        live_loop :perc, sync: :thing do
          tick
          #sample CineElec[/extra/, /glass/].tick(:s), amp: 2.0, start: 0.21, finish: 0.27
          if (ring 1,1,0,1).look == 1
            sample CineElec[/Percussions/,/Pepper/, [0,1]].tick(:sample), amp: 0.5+rand*0.1
          end
          #if (ring 0,0,1,0, 0,0,0,0,  0,1,1,0, 0,0,0,0,  0,0,1,0,0,0,0,1,   0,1,1,0, 0,0,1,0).look == 1
          if (ring
              1,0,1,0, 1,0,1,0,  1,0,1,0, 1,0,1,0,
              1,0,1,0, 1,0,1,0,  1,0,0,1, 0,0,1,1).look == 1
            #sample Words[/beauty/,[3,3]].tick(:s), amp: 8.0, start: 0.1, finish: 0.11 + [0.04,0.0].choose
            sample CineElec[/one shots/,/hat/,[10,10,9]].tick(:hat), amp: 1.0
            #sample CineElec[/one shots/,/hat/,[10,10,3,10]].look, amp: 0.5,  cutoff: 100
          end
          if (ring
              0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
              0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0).look == 1
            sample Abstract[/one shots/,/layered/, /open/,2], amp: 0.5, start: 0.0
            
            p = (ring [rand*0.25,rand*0.5]).tick(:pos)
            with_fx :echo, feedback: rand*0.5, phase: 0.5, decay: 8, mix: [1.0,0.0].choose do
              sample(Words[/beauty/,[3,3]].tick(:s), amp: 2.0, start: p[0], finish: p[1])
              #sample Frag[/coil/,/f#m/,4], amp: 1.55
            end
          end
          sleep 0.25
        end
