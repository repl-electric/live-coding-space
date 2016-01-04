_=nil; set_volume! 1.5; use_bpm 60
live_loop :go do
  flow_time = (knit 4,2, 8,2, 16, 1, 8,1, 16,1).tick(:flowing); puts "flow: #{flow_time}"
  cs = ring(
    chord(:FS3, :m),
    chord(:FS3, :m, invert: 1),
    chord(:A3, :M),
    chord(:A3, :M, invert: -1),
    chord(:Cs3, :m7),
    chord(:D3, :M),
    chord(:E3, 'M')+ [:D3],

    chord(:FS3, :m),
    chord(:FS3, :sus4, invert: 1),
    chord(:A3, :M),
    chord(:A3, :M, invert: -1),
    chord(:Cs3, :m7, invert: 1),
    chord(:D3, :M),
  chord(:E3, 'M') + [:D3])
  comment do
    cs = ring(   chord(:FS3, :m, invert: 0),
                 chord(:FS3, :m, invert: -1),

                 chord(:A2, :maj11),
                 chord(:A3, :M, invert: -1),

                 chord(:Cs3, :m),
                 chord(:D3, '7-5'),
                 chord(:E3, :M) + [])
  end
  comment do
    cs = (ring
          chord(:FS3, :m),
          chord(:FS3, :m, invert: 1),
          chord(:A3, :M),
          chord(:A3, :M, invert: -1),
          chord(:Cs3, :m7),
          chord(:D3, :M),
          chord(:E3, '7'),
          )
  end
  c_old = cs.look(:main)
  c = cs.tick(:main)
  (c_old[0] < c[0]) ? shader(:iDir, 1.0) : shader(:iDir, -1.0)
  
  at do
    comment do
      pos = look(:main)*8
      8.times{|x|
        i_hollow deg_seq(:fs4, %w{1 3 4 1 1 1 6 1
                                  7 5 3 1 1 1 4 1
                                  -5 -5 -4 1 1 1 7  3
                                  -5 -5 -4 1 1 1 7  3
                                  -5 -5 -4 1 1 1 7  5
                                  -5 -5 -4 1 1 1 7  6
                                  -5 -5 -4 1 1 1 7  7
                                  })[pos+x], decay: 4.0, amp: 8.0
        sleep 0.25
      }
      sleep 3
      pos = look(:main)*4
      4.times{|x|
        i_hollow deg_seq(:fs4, %w{1 1 -6 -1
                                  1 1 -6 -1
                                  3 5 -3 -3
                                  3 5 -5 -3
                                  5 5 -7 -5
                                  6 5 -4 -6
                                  7 5 -5 -7
                                  })[pos+x], decay: 4.0, amp: 8.0
        sleep (ring 0.25).tick
      }
    end
    sleep 4
  end

  #c = []
  puts note_inspect(c)
  with_fx(:reverb, room: 0.9, mix: 0.9, damp: 1.0) do |r_fx|
    #sample Organ[/_#{note_info(c[2]+ring(5,0,0,0).tick(:offset) ).midi_string.gsub(/3|2|4/,'1').gsub("s","#")}_/,[0,0]].tick(:sample), amp: 2.5, release: 0.5, attack: 0.5
  end
  comment do
    at do
      with_fx(:reverb, room: 0.9, mix: 0.9, damp: 0.5) do |r_fx|
        sample  Instruments[/double/,/_#{note_info(c[0]).midi_string.gsub(/3|2|4/,'1').gsub("s","s")}_/,[0,0]].tick(:sample), cutoff: 55, amp: 1.2
        sleep 4
        with_fx :echo, decay: 8.0 do
          sample  Instruments[/double/,/_#{note_info(c[1]).midi_string.gsub(/3|2|4/,'1').gsub("s","s")}_/,[0,0]].tick(:sample), cutoff: 65, amp: 1.5
        end
      end
    end

    at do
      sleep 4
      with_fx :reverb, room: 0.9, mix: 0.9, damp: 0.0 do
        with_fx :echo, decay: 16, mix: rand*0.5 do
          #sample Instruments[/violin/,/_#{note_info(c[0]).midi_string.gsub(/3|2|4/,'4').gsub("s","s")}_/,[0,0]].tick(:sample), cutoff: 60, amp: 1.5
        end
        sleep 4
        #sample Instruments[/violin/,/_#{note_info(c[0] + (ring 5,5,5,5).tick(:offset)).midi_string.gsub(/3|2|4/,'4').gsub("s","s")}_/,[0,0]].tick(:sample), cutoff: 65, amp: 1.5
      end
    end
  end
  _=nil
  s1,s2,s3=nil

  #synth :hollow, note: ring(c[0]-5, c[0], c[0]).tick(:cut), release: 4.0, decay: 10.0, amp: 0.2, attack: 4.0, cutoff: 80

  with_transpose -12*2 do
    s3 = synth :dark_sea_horn, note: c[0], decay: flow_time/2.0, cutoff: 130, amp: 0.8, attack: 0.0, noise1: 1.5, noise2: 1.5
  end

  with_fx :pitch_shift do
    with_transpose 12 do
      #s1 = synth :dark_sea_horn, note: c[0], decay: flow_time+0.1, cutoff: 60+rand, amp: 0.2+rand*0.1
      #synth :leadsaw, note: c, attack: 0.1, cutoff: 130, amp: 0.1, release: 8.0, decay: 8.0, sustain: 8.0
    end
    s1 = synth :dark_sea_horn, note: c[1], decay: flow_time+0.1, cutoff: 60+rand, amp: 0.2+rand*0.1
    sleep 1
    s2 = synth :dark_sea_horn, note: c[2], decay: flow_time-1.0, cutoff: 65+rand, amp: 0.2+rand*0.1
    sleep 1
    s3 = synth :dark_sea_horn, note: c[0], decay: flow_time-5.0, cutoff: 65+rand, amp: 0.2+rand*0.1
  end

  sop_notes = ring( 14, 15, 16, 15).look(:main)
  cue :apeg

  at do
    sleep 8
    with_fx(:reverb, room: 1.0, mix: 0.8, damp: 0.5) do |r_fx|
      with_fx :tanh do
        #sample Sop[/sustain/,/Yeh p/, sop_notes], cutoff: 60, amp: 0.1 if sop_notes
      end
    end
    sleep 15-8
    with_fx(:reverb, room: 1.0, mix: 0.8, damp: 0.5) do |r_fx|
      with_fx :distortion, mix: 0.3 do
        #sample Sop[/sustain/,/Mm p/, sop_notes], cutoff: 100, amp: 0.1 if sop_notes
      end
    end
    sleep 1
  end

  if c.length > 4
    s3 = synth :dark_sea_horn, note: c[3], decay: flow_time - 5, cutoff: 69+rand, amp: 0.3+rand*0.1
  end
  if c.length > 3
    s3 = synth :dark_sea_horn, note: c[-1], decay: flow_time/2.0, cutoff: 130, amp: 1.0,  noise1: 0.1, noise2: 3, attack: 4.0
  end

  sleep 0
  mess = [s1].reject{|x|x.nil?}.choose
  (flow_time-2).times{ |n|
    #control mess, note: scale(:Fs3, :minor_pentatonic, num_octaves: 1).shuffle.choose
    #control mess, note: :Fs3
    sleep 1
  }
end

with_fx :pitch_shift, time_dis: 0.8,  pitch_dis: 0.8 do
  live_loop :end do
    sample_and_sleep Mountain[/cracklin/], rate: 0.9, amp: 0.05
  end
end

live_loop :beat do
  sync :go
  with_fx :echo, phase: 1.0, decay: 0.5 do
    #sample Mountain[/subkick/,[0,0,0,0]].tick(:sample), cutoff: 80, amp: 0.1
  end
  #  with_fx(:slicer, phase: ring( 2.0,2.0,1,1).tick(:ph), probability: 0) do

  with_fx :bpf, centre: ring( :FS1, :FS2, :FS3, :FS4).tick(:bcut), mix: 1.0 do
    #sample Organic[/loop/, 11], amp: 0.2, beat_stretch: 16, cutoff: 80
  end
  #sample Abstract[/perc/, 11], cutoff: 130, beat_stretch: 16, amp: 0.2
  #sample Dust[/perc/, 1], beat_stretch: 16.0, cutoff: 90

  comment do
    with_fx :bpf do
      with_fx :slicer, phase: 1.0, phase_offset: 1.0, smooth: 0.05 do
        sample Organic[/loop/, 11], amp: 0.1, beat_stretch: 16, cutoff: 95
      end
      with_fx :slicer, phase: 1.0, phase_offset: 8.0, smooth: 0.05 do
        sample Organic[/loop/, 11], amp: 0.1, beat_stretch: 16, cutoff: 80, rate: -1
      end
    end
  end

  with_fx(:pitch_shift, mix: 0.1, time_dis: 0.01) do
    with_fx :slicer, mix: 1.0 do
      with_fx :bitcrusher, bits: 64*8, mix: 0.04, sample_rate: 40000 do
        #sample Organic[/loop/, 11], amp: 0.1, beat_stretch: 16, cutoff: 80
        #sample Organic[/loop/, 11], amp: 0.07, beat_stretch: 16*2,    cutoff: 100
        #sample Organic[/loop/, 11], amp: 0.08, beat_stretch: 16/2.0,  cutoff: 100

        with_fx(:slicer, phase: 0.25*2) do
          # sample Organic[/loop/, 11], amp: 0.3, beat_stretch: 16, cutoff: 80, rate: -1
        end

      end
    end
  end

  with_fx :bpf, centre: ring( :FS1, :FS2, :FS3, :FS4).tick(:bcut), mix: 0.8 do
    with_fx :hpf, cutoff: 100, mix: 1.0 do
      with_fx :bitcrusher, bits: 64*8, mix: 0.04+rand*0.1, sample_rate: 40000 do
        sample CineAmbi[/kick/,0], amp: 0.2, beat_stretch: 16, cutoff: 80
      end
    end
  end

  #sleep 1
  #sample Mountain[/subkick/,[0,0]].tick(:sample), cutoff: 80, amp: 4.5

  comment do
    sample Mountain[/subkick/,[2,2]].tick(:sample), cutoff: 60, amp: 0.5

    sleep 2
    sample Mountain[/subkick/,[0,0]].tick(:sample), cutoff: 70, amp: 0.5
    at do
      4.times{
        #i_hollow scale(:Fs3, :minor_pentatonic).shuffle.choose, decay: 4.0
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
        #i_hollow scale(:Fs3, :minor_pentatonic, num_octaves: 2).drop(1).shuffle.choose, decay: 4.0
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
