set_volume! 1.0
_=nil
use_bpm 60
live_loop :bazz, sync: :thing do
  sleep 4
end

with_fx(:reverb, room: 0.9, mix: 0.4, damp: 0.5) do |r_fx|
  live_loop :hollower, sync: :thing do
    _ = []
    notes = (knit
             chord(:a2, :M), 1, _, 11, #1
             chord(:cs3, :m), 1, _, 11,  #6
             chord(:a2, :M), 1, _, 11, #1
             chord(:e2, :M), 1, _, 11, #1
             chord(:Fs2, :m), 1, _, 11, #1
             
             chord(:a2, :M), 1, _, 11, #1
             chord(:fs2, 'm+5'), 1, _, 11,  #6
             chord(:a2, :M), 1, _, 11, #1
             chord(:cs3, :M7), 1, _, 11, #1
             chord(:E3, "M"), 1, _, 11, #1
             
             )
    synth :plucked, note: notes.tick(:bass), decay: 1.25, amp: 1.25
    
    at do
      p = [0.5, 0.25, 0.5,0.25, 0.125, 0.125]
      #synth :dark_sea_horn, note: notes.look(:bass)[0], decay: 2.0, amp: 0.5
      4.times do
        with_transpose -12 do
          # synth :plucked, note: notes.look(:bass)[0], decay: 2.0, amp: 1.25
        end
        sleep (ring *p).tick(:s)/2.0
      end
    end
    with_transpose (knit 0,3, 7.0,0).rotate(3).tick(:t) do
      d = (ring

#C E G A C 
           [:e3, 1],  [:e3, 0.5],  [_, 0.5],     [:a3, 0.5],  [:e3, 1.0], [:cs3, 0.5],    #:E :G :B 6th      :a :c :e  3th
           [:e3, 1],  [:e3, 0.5],  [_, 0.5],     [:a3, 0.5],  [:e3, 1.0], [:cs3, 0.5],
           [:e3, 1],  [:e3, 0.5],  [_, 0.5],     [:a3, 0.5],  [:e3, 1.0], [:cs3, 0.5],
           [_, 1],    [:E3, 0.5],  [:e3, 0.5],  [:a3, 0.5],  [:e3, 1.0],  [:cs3, 0.5],
           ).rotate(3).tick(:n)
      d[1] = d[1]/4.0
        
        d2 = (ring #7 per ring   2   2
              [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
              [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
              [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
              [:fs3, 1], [:cs4, 0.5],[_, 0.5], [_, 0.5],   [:a3, 1.0], [:fs3, 0.5],   #:c :e :g 5th
              
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
              
              [_, 1],  [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
              [_, 1],  [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
              [_, 1],  [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
              [:E1, 8], [:Gs3, 8],[_, 8], [:E3, 0.5], [:B2, 8], [:D3, 8],  #M7th  :e :g :b :d
              
              ).tick(:n2)
        with_fx :echo, phase: 1, decay: 2.0, mix: 0 do
          
          #synth :plucked, note: d2[0], amp: 2.25
          with_transpose 12 do
            synth :hollow, note: d2[0], amp: 8.0, decay: d2[1]/8, cutoff: 70

            synth :hollow, note: (knit
                                  _,16, :gs3, 1, _, 7,
                                  _,16, :a3, 1, _, 7,
                                  _,16, :gs3, 1, _, 7,
                                  _,16, :gs3, 1, _, 7,
                                  _,16, :gs3, 1, _, 7).tick(:d), amp: 2.0*1, decay: 1.0, cutoff: 70

          end
        end

        with_fx :distortion, mix: 0.2 do
          if d[0] == [:fs4]
            n = synth :gpa ,note: d[0],  amp: 1.0*1, release: d[1], note_slide: 0.25,attack: 0.0001, cutoff: 80
            control n, note: :Fs4
          else
            #n = synth :gpa, note: d[0],  amp: 1.9, release: d[1]*2, attack: 0.0001, wave: 6
            n = synth :beep, note: d[0],  amp: 2.0, release: d[1]*2, attack: 0.0001, wave: 2, cutoff: 135
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
        sleep l
      end
    end
    
    live_loop :beat, sync: :thing do
      sample Fraz[/kick/,[2,2]].tick(:sample), cutoff: 130, amp: 2.0
      sleep 1/2.0/2.0
      sleep 1/2.0/2.0
      sleep 1/2.0
      2.times{
        sample Fraz[/kick/,[2,2]].tick(:sample), cutoff: 120, amp: 1.0
        sleep 1/2.0
        sleep 1/2.0
      }
      sample Fraz[/kick/,[2,2]].tick(:sample), cutoff: 120, amp: 1.0
      sleep 1/2.0
      #sample Ether[/snare/,[0,0]].tick(:sample), cutoff: 135, amp: 1.0
      sleep  1/2.0/2.0
      sample Fraz[/kick/,[2,2]].tick(:sample), cutoff: 120, amp: 1.0
      sleep 1/2.0/2.0
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
