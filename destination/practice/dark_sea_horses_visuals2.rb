set_volume! 1.5
shader [:iR, :iB, :iG], 0.2
shader :iWave, 0.4
live_loop :slept_but do
  with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
    sample Corrupt[/instrument/,/fx/,/f#/,[1,1]].tick(:sample), cutoff: 50, amp: 0.0
  end
  #sample CineAmbi[/c#m/,[1,1]].tick(:sample), cutoff: 60, amp: 0.5
  with_fx(:echo, decay: 0.5, mix: 1.0, phase: 0.25) do
    with_fx(:slicer, phase: 0.25, invert_wave: 1) do
      #sample Fraz[/interference/,/f#m/,[1,1]].tick(:sample), cutoff: 60, amp: 0.02, beat_stretch: 16, cutoff: 90
    end
  end
  sleep 16
end

live_loop :something_different____________________________________________________________, sync: :slept_but do
  shader :decay, :iForm, rand, 0.0001
  with_fx(:echo, decay: 0.5, mix: 0.1, phase: 0.25) do
    with_fx(:reverb, room: 0.8, mix: 0.5, damp: 0.5) do |r_fx|
      with_fx(:distortion, mix: 0.01, distort: 0.2) do
        #sample Mountain[/bow/, ring(/f#/, /f#/, /c#/).tick(:bowed)], cutoff: 80, amp: 0.3
      end
    end
  end
  sleep 8
end

live_loop :sop, sync: :slept_but do
  with_fx(:echo, decay: 8.0, mix: 1.0, phase: 0.25) do
    with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
      #      sample Sop[/release/,/mm/, (ring 3,4).tick(:spnote)], cutoff: 70, amp: 0.4
      sleep 8
    end
  end
  sleep 16-8
end

live_loop :loop, sync: :slept_but do
  data  = (ring
           chord(:Fs3, :m), chord(:D3, :M), chord(:E3, :M) + [:D3],
           chord(:Fs3, :m), chord(:A3, :M), chord(:Cs3, :m7))

  chords = data.tick(:main)

  with_fx(:pitch_shift, pitch_dis: 0.01, mix: 0.9) do
    #  synth :dark_sea_horn, note: chords[1], cutoff: 60, release: 4.0, decay: 4.0, amp: 0.1
    sleep 1
    #   synth :dark_sea_horn, note: chords[2], cutoff: 60, release: 4.0, decay: 4.0, amp: 0.1
    sleep 1
    #    synth :dark_sea_horn, note: chords[0], cutoff: 60, release: 4.0, decay: 4.0, amp: 0.1
    #  shader :decay, :iMotion, 0.005, 0.000001

    if chords.length > 3
      #   synth :dark_sea_horn, note: chords[-1], cutoff: 60, release: 4.0, decay: 4.0, amp: 0.1
    end
  end

  #Send the diff between current and future chord
  shader :uniform, :iHorse, note(chords[0]).to_f - note(data.look(:main, offset: 1)[0])

  next_chord_root = chords.look(:main, offset: 1)[0]
  at do
    sleep 4
    with_fx(:reverb, room: 0.6, mix: 0.9, damp: 0.5) do |r_fx|
      #synth :dark_ambience, note: dice(6) > 4 ? chords[1] + 5 : next_chord_root, decay: 6.0, amp: 0.3, attack: 2.0, cutoff: 80
    end
  end

  with_transpose -24 do
    #More bass... Ahh thats better. Headphones rumbling
    synth :dark_sea_horn, note: chords[0], cutoff: 90, release: 4.0, decay: 2.0, amp: 0.3, attack: 1.0,noise1: 0.5, noise2: 0.5
  end
  with_transpose (ring -12).tick(:lets_do_something_silly_with_the_bass) do
    with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
      at do
        #        sample Instruments[/double-bass/,/Fs1/, /_15/].tick(:sample), cutoff: 60, amp: 0.2
        sleep 1
        #       sample Instruments[/double-bass/,/Fs1/, /_15/].tick(:sample), cutoff: 70, amp: 0.3
      end
      #      synth :prophet, note: chords[0], cutoff: 50, amp: 0.1, decay: 2.0, release: 2.0
      #     synth :dsaw,    note: chords[0], cutoff: 50, amp: 0.1, decay: 2.0, detune: 12
    end
  end

  sleep 8-2
end

live_loop :looping_do_loop do
  with_fx(:pitch_shift, time_dis: 0.8) do
    sample_and_sleep Mountain[/cracklin/], rate: 0.9, amp: 0.5
  end
end

live_loop :do, sync: :slept_but do
  shader :uniform, :iBeat, 1.0
  shader :uniform, :iKick, 1.0
  #  sample Fraz[/kick/,[0,0,0,1]].tick(:sample), cutoff: rrand(60,70), amp: 0.2
  #  sample Abstract[/perc/,[5,4]].tick(:sample), cutoff: 60, amp: 0.5, beat_stretch: 8

  sleep 2

  #  shader :decay, :iDistort, rrand(0.05,0.09), 0.0001
  # shader :decay, :iForm, rrand(0.1,0.5), 0.001
  with_fx(:reverb, room: 0.6, mix: 0.9, damp: 0.5) do |r_fx|
    #sample Fraz[/snap/,[0,0,0,1]].tick(:sample), cutoff: rrand(60,70), amp: 0.2
  end
  sleep 2
end
