set_volume! 1.0
_=nil
use_bpm 60
live_loop :thing do
  sleep 4
end
with_fx :wobble, phase: 16, smooth: 0.1, mix: 0.01 do
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
    #synth :dark_sea_horn, note: n.tick[0], amp: 0.25, decay: (ring 0.25, 0.25, 0.25/2.0, 0.25).tick(:D)*8, attack: 0.01, cutoff: 50
    #synth :gpa, note: n.look[0], release: n.look[-1], wave: 6, amp: 8
    #synth :dark_ambience, note: chord(:E5, :M7), amp: 2, decay: 8
    puts note_inspect(n.look[0])
    sleep n.look[-1]*2
  end
end

live_loop :apeg, sync: :thing do
  tick
  s =  (ring [chord(:Fs4,:m), 0.25]#,[_, 0.5],[_, 0.5],[:E3, 0.5],[:E3, 0.5],[_, 0.5], [:D3, 1.0]
        ).look
  with_fx :distortion, mix: (range 0.0, 0.5, 0.1).look do
    #synth :plucked, note: s[0].choose, amp: 0.25, release: (ring 0.25, 0.125, 0.125, 0.125).look, attack: 0.0001, cutoff: (ramp *(range 0, 100)).look
  end
  sleep s[-1]*1
end

with_fx :reverb do
  live_loop :percussion, sync: :thing do
    with_fx :distortion, mix: 0.4 do
      tick
      s = (ring
           _, MagicDust[/hit/,/hi/,8], _, MagicDust[/hit/,/hi/,8], MagicDust[/hit/,/hi/,9], _,
           _, MagicDust[/hit/,/hi/,10], _, _, MagicDust[/hit/,/hi/,11], _,
           MagicDust[/hit/,/low/,8], _, _,  MagicDust[/hit/,/hi/,7], _, _,
           MagicDust[/hit/,/low/,20], _, _, MagicDust[/hit/,/hi/,8], _, _).rotate(0)
      if s.look; sample s.look , amp: 1.0, cutoff: rrand(90,100); end
      sleep 0.25
    end
  end
end

with_fx(:reverb, room: 0.9, mix: 0.3, damp: 0.5) do |r_fx|
  live_loop :hollower, sync: :thing do
    with_transpose (knit  7.0,0,0,3).rotate(0).tick(:t) do
      mscore = (ring
                [:fS3, 0.125],[_, 0.125],[:Cs4, 0.125],[_, 0.125],[:D4, 0.125],[_, 0.125],[:E4,0.25], [_,0.25],
                [:D4,0.5], [:E4, 0.25], [_, 0.125], [:E4,0.5], [_,0.5], [:E4,0.25], [_, 0.5],[:E4,0.25],
                [_, 0.5], [:E4,0.25], [_, 0.5], [_,0.25+0.125],
                [:E4, 0.125], [_, 0.125],[:E4, 0.125],[:E4, 0.125], [:E4, 0.125],[:D4, 0.125], [:E4, 0.25],[_, 0.125], [:E4, 0.125],   [_,0.5], [:D4, 0.25], [_,0.125],
                [:D4,0.5], [:E4, 0.25], [_, 0.125], [:E4,0.5], [_,0.5], [:E4,0.25], [_, 0.5],[:E4,0.25], [_, 0.5], [:E4,0.25], [_, 0.25], [_,0.25],
                )
      d = mscore.tick(:n)
      puts "Score: #{mscore.map(&:last).reduce(&:+)}"
      if(look(:n) % mscore.size == 0); cue :bass end
      
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
          h = synth :hollow, note: d2[0], amp: 1.0*2, decay: d2[1]/8.0, note_slide: 0.125
          synth :hollow, note: (knit
                                _,16, :e3, 1, _, 7,
                                _,16, :gs3, 1, _, 7,
                                _,16, :e3, 1, _, 7,
                                _,16, :e3, 1, _, 7).tick(:d), amp: 1.0*1, decay: 1.0
        end
      end
      if look(:n) % 20 > 10 || look(:n) % 20 == 0
        with_fx :echo, decay: 2, phase: 0.25 do
with_transpose (ring 0, 0).tick(:t) do
         # synth :pretty_bell, note: d[0], amp: 0.1
end
        end
      end
      with_fx :distortion, mix: 0.0 do
        if d[0] == [:fs4]
          #n = synth :gpa ,note: d[0],  amp: 1.0*1, release: d[1], note_slide: 0.25,attack: 0.0001, cutoff: 80
          control n, note: :Fs4
        else
          #n = synth :dark_ambience, note: d[0],  amp: 1.0*1, release: (d[1]*4)+1, attack: 0.0001, wave: 0
with_transpose 0 do
          n = synth :gpa, note: d[0],  amp: 2.8*1, release: (d[-1])+1, attack: 0.001, wave: 0, cutoff: (ramp *(range 0, 60)).tick(:m)
end
          #n = synth :dark_sea_horn, note: d[0],  amp: 4.0, release: d[1]*2, attack: 0.0001, wave: 4, cutoff: 135
        end
        sleep d[-1]
      end
    end
  end
end
live_loop :beat, sync: :thing do
  tick
  main_d = Fraz[/kick/, [0,0]]
          sample Fraz[/kick/,2], cutoff: 130, amp: 1.0+rand
          sleep 1/2.0
          5.times{
            if spread(1,2).tick(:m)
              #sample MagicDust[/click/,9], cutoff: 110, amp: 2.0+rand
            end
            sample main_d.look, cutoff: 80, amp: 1.0+rand
            sleep 1/2.0
          }
          sample main_d.look, cutoff: 80, amp: 1.0+rand
          sleep 1/2.0/2.0
          sample main_d.look, cutoff: 80, amp: 1.0+rand
          sleep 1/2.0/2.0
          sample main_d.look, cutoff: 80, amp: 1.0+rand
          sleep 1/2.0
          
        end
        
        live_loop :perc, sync: :thing do
          tick
          #sample CineElec[/extra/, /glass/].tick(:s), amp: 2.0, start: 0.21, finish: 0.27
          if (ring 1,1,0,1).look == 1
            #sample CineElec[/Percussions/,/Pepper/, [0,1]].tick(:sample), amp: 0.15+rand*0.01
            #sample MagicDust[/low/,[12,12]].tick(:sample), amp: 0.15#+rand*0.01
            
          end
          #if (ring 0,0,1,0, 0,0,0,0,  0,1,1,0, 0,0,0,0,  0,0,1,0,0,0,0,1,   0,1,1,0, 0,0,1,0).look == 1
          if (ring
              1,0,1,0, 1,0,1,0,  1,0,1,0, 1,0,1,0,
              1,0,1,0, 1,0,1,0,  1,0,0,1, 0,0,1,1).look == 1
            #sample Words[/beauty/,[3,3]].tick(:s), amp: 8.0, start: 0.1, finish: 0.11 + [0.04,0.0].choose
            # sample CineElec[/one shots/,/hat/,[10,10,9]].tick(:hat), amp: 1.0
            #sample CineElec[/one shots/,/hat/,[10,10,3,10]].look, amp: 0.5,  cutoff: 100
          end
          if (ring
              0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
              0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0).look == 1
            #  sample Abstract[/one shots/,/layered/, /open/,2], amp: 0.5, start: 0.0
            
            p = (ring [rand*0.25,rand*0.5]).tick(:pos)
            with_fx :echo, feedback: rand*0.5, phase: 0.5, decay: 8, mix: [1.0,0.0].choose do
              #sample(Words[/beauty/,[3,3]].tick(:s), amp: 2.0, start: p[0], finish: p[1])
              #sample Frag[/coil/,/f#m/,4], amp: 1.55
            end
          end
          sleep 0.25
        end
