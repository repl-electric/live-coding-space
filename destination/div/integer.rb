_=nil
bar=1
#with_fx :pitch_shift, pitch_dis: 0.01 do

live_loop :sop do
  sync :warm
  #Double reverb..... and echo... yup too much..
  with_fx((knit :reverb,3, :echo, 1).tick(:fx), room: 0.9, mix: 0.9, damp: 0.5, decay: 16.0) do |r_fx|
    with_fx((knit :reverb,3, :none, 1).look(:fx), room: 0.9, mix: 0.9, damp: 0.5, decay: 16.0) do |r_fx|
      # sample Sop[/yeh/,[4,4]].tick(:yeh), cutoff: 60, amp: 1.2
    end
  end
end

live_loop :vocalm do
  2.times{sync :warm}
  #  sample Fraz[/coil/,/c#/,1], cutoff: 60, amp: 1.0
end

live_loop :beat do
  with_fx :lpf, cutoff: 100 do

    #sync :warm
    # shader :iBeat, 0.8
    # with_fx(:krush, mix: 0.00000001) do |r_fx|
    #  sample Abstract[/kick/,12..13].tick, cutoff: 100+rand, amp: 0.5+rand
    #end

    with_fx(:reverb, room: 0.9, mix: 0.4, damp: 0.5) do |r_fx|
      if spread(1,2).tick(:d)
        #        sample Mountain[/ice/,0..2].tick(:ice), cutoff: 50, amp: 0.4
      end
    end
    sleep 2
  end
end

live_loop :slither do
  with_fx :lpf, cutoff: 100 do
    #sync :warm
    sleep 0.25
    if spread(1,8).tick

      with_fx :bitcrusher, bits: (range 8,12).tick(:bits),mix: 0.1 do
        # sample Abstract[/one shot/,8], cutoff: (ring 80,90,100).tick(:c), amp: 0.3
      end

    end
    if spread(1,14).look
      #sample Abstract[/one shot/,[9,9]].tick(:s), cutoff: (ring 80,90,100).tick(:c), amp: 0.8, rate: 1
    end

    if spread(1,16).look
      #     sample Mountain[/stone/,0], cutoff: 80, amp: 0.2
    end
  end
end

with_fx :pitch_shift, time_dis: 0.01 do
  live_loop :crak do
    sample_and_sleep Mountain[/cracklin/, 0], rate: 0.9, amp: 0.5
  end
end

live_loop :warm do
  notes = ring([:Fs3]).tick(:bassey)
  #notes = ring([:Fs3, :AS3, :cs3]).tick(:bassey)
  with_fx(:reverb, room: 0.9, mix: 0.4, damp: 0.5) do |r_fx|
    with_fx(:pitch_shift, time_dis: 0.01) do
      #      synth :dsaw, cutoff: 40, note: notes[4], amp: 0.2, decay: 8.0, detune: 12
      #     synth :growl, cutoff: 80, note: notes[0], amp: 0.4, decay: 4.0, release: 3.0
    end
  end

  s1,s2,s3=_

  with_transpose -12 do
    sleep 1
    #  s1 = synth :dark_sea_horn, note: notes[0], cutoff: 50, decay: 8.0, amp: 0.2
    # s2 = synth :dark_sea_horn, note: notes[1], cutoff: 50, decay: 8.0, amp: 0.2
  end
  #s3 = synth :dark_sea_horn, note: notes[2], cutoff: 45, decay: 8.0

  n  = (ring
        :Fs4, _, :Cs4,
        :Fs4, _, :Cs4,
        :Fs4, _, :Cs4,
        :Fs4, :A3, :Cs4,

        :A4, _,  :E4,
        :A4, _,  :E4,
        :A4, _,  :E4,
        :A4, :A3, :E4,

        #        :Cs4, _,  :E4,
        #        :Cs4, _,  :E4,
        #        :Cs4, _,  :E4,
        #        :Cs4, :Cs3, :E4,

        #        :D4, _,  :E4,
        #        :D4, _,  :E4,
        #        :D4, _,  :E4,
        #        :D4, :Fs3, :Gs4,

        #        :E4, _,  :B3,
        #        :E4, _,  :B3,
        #        :E4, _,  :B3,
        #        :E4, :Gs3, :B3
        )

  with_fx :echo, decay: 8.0 do
    with_fx(:pitch_shift, time_dis: 0.01) do
      with_fx :distortion, mix: 0.7, distort: 0.5 do
        with_transpose(12) do
          at do
            2.times{
              z2 = synth :beep, note: (ring _,_,n).look(:notes).tick(:apeg), cutoff: 60, amp: 0.01
              z1 = synth :plucked, note: (ring _,_,n.look(:notes),  _,_, scale(:fs4, :minor_pentatonic).shuffle.choose).tick(:apeg), cutoff: 50, amp: 0.45
              sleep 2

              with_transpose(12) do
                control z1, note: n
              end

            }
          end
        end
      end
    end
  end


  7.times{
    candidate = scale(:FS3, :minor_pentatonic, num_octaves: 1).drop(1).shuffle.choose
    #    control s1, note: (ring :FS4, :A4, :Cs3).tick, noise1: ring(32.25).tick(:n1), noise2: 0, amp: 1.0,  max_delay: 0.5

    if spread(1,7).tick(:s)
      shader :iMotion, rrand(0.1, 0.2)
      #synth :hollow, note: (ring :Cs3, :E3).tick(:hnotes), decay: 4.0, attack: 1.0, cutoff: 80, release: 4.0, amp: 0.6

      with_fx((ring :slicer,:reverb).tick(:play), phase: 0.25*2, probability: 0, wave: 0.0, smooth: 0.5) do
        #synth :hollow, note: :A3, decay: 8.0, attack: 1.0
      end
      with_fx(:slicer, phase: 0.25*2, invert_wave: 1, probability: 0, wave: 0, smooth: 0.5) do
        #synth :hollow, note: :E2, decay: 8.0, attack: 1.0
      end
    end

    #    s = synth :gpa, note: n.tick(:notes), decay: 0.75, amp: 0.1, wave: 6, note_slide: 0.1
    n.tick(:notes)
    sleep 1
    #   control s, note: n.look(:notes)

    #    with_fx :slicer, phase: 0.25 do
    #synth :gpa, note: (ring :Gs4, :E3).tick(:hnotes),
    #decay: 0.25, attack: 1.0, cutoff: 80, release: 0.25, amp: 0.9
    #   end

    if spread(1,4).look(:s)
      #synth :dsaw, note: :Fs1, cutoff: 40, decay: 1.0
      #I'm suspecting this is not coming through....
    end
  }
end
#end
