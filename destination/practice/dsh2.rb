set_volume! 2.5
_=nil
use_bpm 60

live_loop :apegy do
  sync :apeg
  apeg = deg_seq(:fs3, %w{1 1 2 1   1 3 1 1   1 1 4 4   2 3 1 1
                          1 1 2 1   1 3 1 1   1 1 4 4   3 3 4 4

                          1 1 2 1   1 3 1 1   1 1 4 4   2 3 1 1
                          1 1 2 1   1 3 1 1   1 1 4 4   3 3 5 5

                          3 3 2 3   3 3 3 3   3 3 4 4   2 3 1 1
                          3 3 2 3   3 3 3 3   3 3 4 4   3 3 5 5

                          3 3 2 3   3 3 3 3   3 3 4 4   2 3 1 1
                          3 3 2 3   3 3 3 3   3 3 4 4   3 3 5 5

                          5 5 2 5   5 5 5 5   5 5 4 4   2 3 1 1
                          5 5 2 5   5 5 5 5   5 5 4 4   3 3 5 5
                          })

  32.times{
    #    chord(:FS3, :m, invert: 0),
    #   chord(:FS3, :m, invert: -1),

    #  chord(:A2, :maj11),
    # chord(:A3, :M, invert: -1),
    #
    #   chord(:Cs3, :m),
    #   chord(:D3, '7-5'),
    #   chord(:E3, :M) + [],

    n = apeg.tick(:dark2)
    synth :leadsaw, note: n, attack: 0.0, cutoff: 70
    synth :dark_sea_horn, note: n, attack: 0.2, decay: 0.15, amp: 5.0, noise1: 1.0, noise2: 0.02, max_delay: 0.15, release: 0.2
    sleep 0.5
  }
end

live_loop :go do
  cs = ring(
    #   chord(:FS3, :m),        # 5 in
    #  chord(:FS3, :m, invert: 1),
    #[:Fs3, :B3,  :Cs4, _],        #sus4 1
    #  chord(:A3, :M),
    #  chord(:A3, :M, invert: -1),
    #  chord(:Cs3, :m7),
    #  chord(:D3, :M),
    #  chord(:E3, :M) + [:D3],

    #    chord(:FS3, :m),        # 5 in
    #   chord(:FS3, :sus4, invert: 1),
    #[:Fs3, :B3,  :Cs4, _],        #sus4 1
    #  chord(:A3, :M),
    # chord(:A3, :M, invert: -1),
    #chord(:Cs3, :m7, invert: 1),
    #  chord(:D3, :M),
    #  chord(:E3, :M) + [:D3],


    chord(:FS3, :m, invert: 0),        # 5 in
    chord(:FS3, :m, invert: -1),

    chord(:A2, :maj11),
    chord(:A3, :M, invert: -1),

    chord(:Cs3, :m),
    chord(:D3, '7-5'),
    chord(:E3, :M) + [],

    #    chord(:FS3, :sus2),        # 5 in
    #    chord(:FS3, :sus2, invert: 1),
    #[:Fs3, :B3,  :Cs4, _],        #sus4 1
    #    chord(:A3, :M),
    #    chord(:A3, :M, invert: -1),
    #    chord(:Cs3, :m7, invert: 1),
    #    chord(:D3, :M),
    #    chord(:E3, :M) + [:D3],

  )
  c = cs.tick(:main)
  #c = []
  puts note_inspect(c)


  synth :hollow, note: ring(c[0]-5, c[0], c[0]).tick(:cut), release: 4.0, decay: 10.0, amp: 0.2, attack: 4.0, cutoff: 80

  with_transpose -12*2 do
    #s1 = synth :gpa, note: ring(  c[0]).tick(:bassvoice), decay: 4.0, cutoff: 70, amp: 2.0, wave: 6
  end
  #synth :leadsaw, note: :Gs4,  amp: 0.8, decay: 16.0, amp: 0.4
  #synth :dsaw,  note: :Gs4, cutoff: 60, amp: 0.4, decay: 16.0, detune: 12, attack: 0.1

  with_transpose -12 do
    with_fx(:reverb, room: 0.9, mix: 0.4, damp: 0.5) do |r_fx|
      #   synth :dsaw,  note: c[0]+0, cutoff: 60, amp: 0.5, decay: 8.0, detune: 12, attack: 0.1
      #   synth :prophet, note: c[0]+0, cutoff: 60, amp: 0.5, decay: 8.0,attack: 0.1
    end
  end

  _=nil
  s1,s2,s3=nil


  with_transpose -12*2 do
    #s3 = synth :dark_sea_horn, note: c[0], decay: 8.0, cutoff: 130, amp: 0.6, attack: 0.0, noise1: 3.0, noise2: 3.0
  end

  with_transpose 12 do
    synth :leadsaw, note: c, attack: 0.1, cutoff: 130, amp: 0.1, release: 8.0, decay: 8.0, sustain: 8.0
  end
  #s = synth :dsaw,  note: c, attack: 0.1, cutoff: 80, sustain: 1.0, release: 1.0, decay: 8.0, amp: 0.1, detune: 12
  s1 = synth :dark_sea_horn, note: c[1], decay: 16.1, cutoff: 60+rand, amp: 0.2+rand*0.1
  sleep 1
  s2 = synth :dark_sea_horn, note: c[2], decay: 15.0, cutoff: 65+rand, amp: 0.2+rand*0.1
  sleep 1
  s3 = synth :dark_sea_horn, note: c[0], decay: 11.0, cutoff: 65+rand, amp: 0.2+rand*0.1
  # at do
  #    sync :fire
  #    puts :ping
  #s3 = synth :dark_sea_horn, note: c[0], decay: 11.0, cutoff: 65+rand, amp: 0.2+rand*0.1, attack: 0.001
  #end
  #sting1  = ring(/F#_/, /A_/, /C#_/, /D_/, /E_/).tick(:bow)
  #ting2   = ring( /C#/, /A_/, /A_/, /C#_/, /D_/,/D_/, /E_/, /E_/).tick(:bow)

  sop_notes = (ring 14, 15, 16, 15).tick(:sop)

  cue :apeg

  at do
    sleep 8
    with_fx(:reverb, room: 1.0, mix: 0.8, damp: 0.5) do |r_fx|
      with_fx :tanh do
        sample Sop[/sustain/,/Yeh p/, sop_notes], cutoff: 60, amp: 0.1 if sop_notes
      end
    end
    sleep 15-8
    with_fx(:reverb, room: 1.0, mix: 0.8, damp: 0.5) do |r_fx|
      with_fx :distortion, mix: 0.3 do
        sample Sop[/sustain/,/Mm p/, sop_notes], cutoff: 100, amp: 0.1 if sop_notes
      end
    end
    sleep 1
  end

  if c.length > 3
    # s3 = synth :dark_sea_horn, note: c[-1], decay: 8.0, cutoff: 130, amp: 1.0,  noise1: 0.1, noise2: 3, attack: 4.0
  end

  with_fx(:reverb, room: 0.9, mix: 0.4, damp: 0.5) do |r_fx|
    #synth :hollow,        note: c[-1], amp: 1.5, release: knit( 8.0,3, 16,1).tick(:release), decay: 8.0, attack: 4.0, cutoff: 70
    #synth :dark_ambience, note: c[-1] + ring( 0).tick(:bass), amp: 0.2, release: knit( 8.0,3, 16,1).tick(:release)/2.0, decay: 8.0/2.0, attack: 4.0, cutoff: 70
  end


  sleep 0
  mess = [s1,s2,s3].reject{|x|x.nil?}.choose
  (16-2).times{ |n|
    #control mess, note: scale(:Fs3, :minor_pentatonic, num_octaves: 1).shuffle.choose
    #control mess, note: :Cs3

    sleep 1

    if n == 5
      puts "ping"

      #s3 = synth :dark_sea_horn, note: c[2], decay: 11.0, cutoff: 65+rand, amp: 0.2+rand*0.1
    end

    if  n == 10
      #s4 = synth :dark_sea_horn, note: cs.look(:main)[0], attack: 0.0, decay: 8.0, cutoff: 65+rand, amp: 0.2+rand*0.1

      #sample Organic[/kick/,[1,1]].tick(:sample), cutoff: 100, amp: 0.2
      with_transpose -12*2 do
        #   s1 = synth :gpa, note: ring(  c[0]).look(:bassvoice), decay: 4.0, cutoff: 60, amp: 2.0, wave: 6
      end
    end

  }
end

with_fx :pitch_shift, time_dis: 0.8,  pitch_dis: 0.8 do
  live_loop :end do
    sample_and_sleep Mountain[/cracklin/], rate: 0.9, amp: 0.1
  end
end

live_loop :hollow do
  sync :go
  #control mess, note: :Fs3 #scale(:Fs3, :minor_pentatonic).shuffle.choose#, noise1: 0.0
  8.times{
    #sample Organic[/perc/, 8], amp: range( 0.01, 0.0).tick(:amp)*0.08
    #i_hollow scale(:Fs4, :minor_pentatonic).shuffle.choose, amp: 8.0*3
    sleep 0.25
    #sample Organic[/perc/, 9], amp: 0.0
    sleep 0.25
  }
  8.times{
    #sample Organic[/perc/, 8], amp: 0.05
    sleep 0.25
    sleep 0.25
  }
end



live_loop :beat do
  sync :go
  #sample Mountain[/subkick/,[0,0,0,0]].tick(:sample), cutoff: 80, amp: 0.2
  #  with_fx(:slicer, phase: ring( 2.0,2.0,1,1).tick(:ph), probability: 0) do
  with_fx(:pitch_shift, mix: 0.0, time_dis: 0.01) do
    with_fx :slicer, mix: 0.0 do
      with_fx :bitcrusher, bits: 64*8, mix: 0.04, sample_rate: 40000 do
        #sample Organic[/loop/, 11], amp: 0.2, beat_stretch: 16, cutoff: 130
        #   sample Organic[/loop/, 11], amp: 0.1, beat_stretch: 16*2,    cutoff: 100
        #        sample Organic[/loop/, 11], amp: 0.1, beat_stretch: 16/2.0,  cutoff: 100

        with_fx(:slicer, phase: 0.25*2) do
          #      sample Organic[/loop/, 11], amp: 0.3, beat_stretch: 16, cutoff: 80, rate: -1
        end

      end
    end
  end

  #sample CineAmbi[/kick/,0], amp: 0.01, beat_stretch: 16
  #sleep 1
  #sample Mountain[/subkick/,[0,0]].tick(:sample), cutoff: 80, amp: 4.5

  comment do
    sample Mountain[/subkick/,[2,2]].tick(:sample), cutoff: 60, amp: 0.5

    sleep 2
    sample Mountain[/subkick/,[0,0]].tick(:sample), cutoff: 70, amp: 0.5
    at do
      4.times{
        i_hollow scale(:Fs3, :minor_pentatonic).shuffle.choose, decay: 4.0
        sleep 0.25
      }
    end
    cue :fire
    sleep 2

    sample Mountain[/subkick/,[0,0]].tick(:sample), cutoff: 80, amp: 0.5
    sleep 2
    cue :fire

    #i_hollow :A4, amp: 2, decay: 4.0
    sleep 2

    sample Mountain[/subkick/,[0,0]].tick(:sample), cutoff: 80, amp: 0.5
    sleep 2
    cue :fire
    at do
      4.times{
        i_hollow scale(:Fs3, :minor_pentatonic, num_octaves: 2).drop(1).shuffle.choose, decay: 4.0
        sleep 0.25
      }
    end
    sleep 2

    sample Mountain[/subkick/,[0,0]].tick(:sample), cutoff: 90, amp: 0.5
    sleep 2
    cue :fire
    #i_hollow :E4, amp: 2, decay: 4.0
    sleep 2
  end
  #sleep 16

end
