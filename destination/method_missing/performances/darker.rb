_=nil
live_loop :thing do
  sleep 4
end

live_loop :beat, sync: :thing do
  main_d = MagicDust[/dirt/,[17,17]].tick(:sample)
  cut = 50
  6.times{
    sample main_d, cutoff: cut, amp: 3.0+rand
    sleep 1/2.0
    sleep 1/2.0
  }
  sample main_d, cutoff: cut, amp: 3.0+rand
  sleep 1/2.0/2.0
  sample main_d, cutoff: cut, amp: 3.0+rand
  sleep 1/2.0/2.0
  sample main_d, cutoff: cut, amp: 3.0+rand
  sleep 1/2.0
end

#     [:D4, 0.25], [:D4, 0.25], [:D4, 0.25], [:E4,0.25], [_,0.25],  [:D4, 0.25], [:E4,0.25],[_,0.25],
#    [:D4, 0.25], [:D4, 0.25], [:D4, 0.25], [:E4,0.25], [_,0.25],[_,0.25],[_,0.25], [:D4, 0.25], [:E4,0.25], [_,0.5]

with_fx :wobble, phase: 16, mix: 0 do
  with_fx :distortion, mix: 0.7 do
    live_loop :melody, sync: :thing do
      #  sync :second_voice
      tick
      score = (ring
               [:D4, 0.125],[_, 0.125], [:D4, 0.125],[_, 0.125],[:D4, 0.125],[_, 0.125],[:D4,0.25], [_,0.25],
               [:D4,0.5], [:E4, 0.25], [_, 0.125], [:E4,0.5], [_,0.5], [:D4,0.125], [_, 0.5],[:E4,0.125], [_, 0.5], [:E4,0.125], [_, 0.5], [:D3,0.25], [_,1.0],
               [:E4, 0.125], [_, 0.125],[:E4, 0.125],[_, 0.125], [:E4, 0.125],[:D3, 0.125], [:E4, 0.125],[_, 0.125], [:E4, 0.125], [_,0.5], [:E4, 0.25], [_,1.0],
               [_, 16-9.125]
               )
      note = score.look
      puts score.map(&:last).reduce(&:+)
      #synth :dark_sea_horn, note: :FS2, release: 0.125, attack: 0.001, amp: 1
      with_transpose -12*2 do
        #synth :gpa, note: note[0], release: note[-1]*2, wave: 4, attack: 0.1, amp: 1/2.0
        synth :dark_sea_horn, note: note[0], release: note[-1], attack: 0.001, amp: 3
        sleep score.look[-1]
      end
    end
    # }
  end
end

live_loop :perc, sync: :thing do
  tick
  #sample CineElec[/extra/, /glass/].tick(:s), amp: 2.0, start: 0.21, finish: 0.27
  if (ring 1,1,0,1).look == 1
    #sample CineElec[/Percussions/,/Pepper/, [0,1]].tick(:sample), amp: 0.5+rand*0.01, cutoff: 100
  end
  #if (ring 0,0,1,0, 0,0,0,0,  0,1,1,0, 0,0,0,0,  0,0,1,0,0,0,0,1,   0,1,1,0, 0,0,1,0).look == 1
  if (ring
      1,0,1,0, 1,0,1,0,  1,0,1,0, 1,0,1,0,
      1,0,1,0, 1,0,1,0,  1,0,0,1, 0,0,1,1).look == 1
    #sample Words[/beauty/,[3,3]].tick(:s), amp: 8.0, start: 0.1, finish: 0.11 + [0.04,0.0].choose
    #sample CineElec[/one shots/,/hat/,[10,10,9]].tick(:hat), amp: 0.125, cutoff: 100
    #sample CineElec[/one shots/,/hat/,[10,10,3,10]].look, amp: 0.5,  cutoff: 100
  end
  if (ring
      0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
      0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0).look == 1
    #sample Abstract[/one shots/,/layered/, /open/,2], amp: 0.5, start: 0.0
    
    p = (ring [rand*0.25,rand*0.5]).tick(:pos)
    with_fx :echo, feedback: rand*0.5, phase: 0.5, decay: 8, mix: [1.0,0.0].choose do
      #sample(Words[/beauty/,[3,3]].tick(:s), amp: 2.0, start: p[0], finish: p[1])
      #sample Frag[/coil/,/f#m/,4], amp: 1.55
    end
  end
  sleep 0.25
end

live_loop :second_voice, sync: :thing do
  with_fx :distortion, mix: 0.7 do
    rand_reset
    p = [0.25, 0.5].shuffle
    with_fx :wobble, phase: 16, invert_wave: 0  do
      with_fx :slicer, phase:  p[0], probability: 0.5  do
        #synth :dark_sea_horn, note: chord(:E2, :M7)[0], amp: 0.125, decay: 4
        #synth :dark_ambience, note: chord(:E4, :M), amp: 2, decay: 8
      end
      with_fx :slicer, phase: 0.25, probability: 0.5, invert_wave: 1  do
        #synth :dark_sea_horn, note: chord(:Fs2, :m11)[0], amp: 2, decay: 4
        #synth :dark_ambience, note: chord(:Fs6, :m11), amp: 2, decay: 8
      end
      with_fx :slicer, phase: p[1], probability: 0.5, invert_wave: 1  do
        #synth :dark_sea_horn, note: chord(:D2, :M7)[0], amp: 0.125, decay: 4
        #synth :dark_ambience, note: chord(:D4, :M), amp: 2, decay: 4
      end
    end
  end
  sleep 16/2.0/2.0
end

live_loop :melo, sync: :thing do
  tick
  score= (ring
          [chord(:Fs3, :m),2],
          [chord(:E3, :M),2],
          [chord(:D3, :M),2])
  c = score.look
  synth :gpa, wave: 6, note: c[0], amp: 2, release: 10
  sleep 16
end
