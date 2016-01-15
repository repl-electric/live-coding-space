set_volume! 1.0

live_loop :kickers, sync: :warm do
  with_fx((knit :reverb,3, :none,1).tick(:E), decay: 0.5+rand, mix: 0.3, phase: 0.25) do
    sample Fraz[/kick/,[0,0]].tick(:sample), cutoff: 60, amp: 0.1
  end
  shader :decay, :iKick, 1.0
  shader :decay, :iBeat, 1.0
  sleep 2

  with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
    sample Fraz[/snap/,[0,0]].tick(:sample), cutoff: 60, amp: 0.1
    shader :decay, :iDistort, rrand(0.01, 0.05), 0.0001
    shader :decay, :iForm, rrand(0.01, 0.5), 0.0001
  end
  sleep 2
end

live_loop :warm do
  sample Fraz[/interference/,/f#m/].tick(:sample), cutoff: 60, amp: 0.01, beat_stretch: 16
  #shader [:iR, :iB, :iG], rand*1, rand*4, rand*2
  s = (ring 8,8,4,4, 8,8,4,4).tick(:sleeping)
  puts "sleep => #{s}"
  data = ring(
    chord(:FS3, :m),
    chord(:FS3, :m, invert: 1),
    chord(:A3, :M),
    chord(:A3, :M, invert: -1),
    chord(:Cs3, :m7),
    chord(:D3, :M, invert: -1),
    chord(:D3, :M),
    chord(:E3, 'M')+ [:D3],

    chord(:FS3, :m),
    chord(:FS3, :sus4, invert: 1),
    chord(:A3, :M),
    chord(:A3, :M, invert: -1),
    chord(:Cs3, :m7, invert: 1),
    chord(:Cs3, :m7, invert: 0),
    chord(:D3, :M),
    chord(:E3, 'M') + [:D3]
  )

  notes = data.tick(:main)
  #shader :iForm, rrand(0.3,0.4)
  #Grab the next chord not playing yet.
  dis_note =  (data.look(:main, offset: 1).to_a-notes)[0] #unstable note maybe...
  puts "stable=>#{note_inspect(notes)}"
  puts "nextchord#{note_inspect(data.look(:main, offset: 1))}"
  puts "dis => #{note_inspect(dis_note)}"
  _ = nil
  new_note = (ring
              _,_,dis_note,
              _,_,dis_note,).tick(:not_always)

  with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
    with_transpose 0 do
      n = notes[0] + (dice(6) > 3 ? 5 : 0)
      synth :hollow, note: [new_note, n].choose, attack: 4.0, decay: 4.0, amp: 0.3, cutoff: 80
    end
  end

  at do
    sleep 6
    with_transpose 0 do
      _ = :r
      if new_note
        puts "fire----------------> #{new_note}" if new_note
        with_fx(:reverb, room: 0.6, mix: 1.0, damp: 0.5) do |r_fx|
          synth :dark_sea_horn, note: new_note, attack: 0.01, decay: s, amp: 0.025, cutoff: 80
        end
      end
    end

    with_transpose 0 do
      with_fx(:reverb, room: 1.0, mix: 0.3, damp: 0.5) do |r_fx|
        #synth :dark_ambience, note: (ring dis_note, _, _).tick(:not_always), attack: 0.01, decay: 8.0, amp: 1.0, cutoff: 50
      end
    end


  end
  puts note(notes[0]) - note(data.look(:main, offset: -1)[0])
  #Send the diff
  last_diff = (note(note(data.look(:main, offset: -1)[0])) - note(data.look(:main, offset: -2)[0]))
  note_diff = (note(notes[0]) - note(data.look(:main, offset: -1)[0])).to_f
  at do
    puts "#{last_diff} / #{note_diff}"
    acc = 0
    if last_diff > note_diff
      puts "decay:#{ note_diff}"
      shader "decay", :iHorse, note_diff, 0.001
    else
      puts "growing:#{ note_diff}"
      shader "growing-uniform", :iHorse, note_diff, 0.001
    end
  end

  with_fx :pitch_shift, mix: 0.0 do
    with_transpose -24 do
      bass_dsh =  synth :dark_sea_horn, note: notes[0], decay: 2, cutoff: 130, amp: 0.01, note_slide: 0.01
    end

    dsh = synth :dark_sea_horn, note: notes[1], decay: s, cutoff: 60, amp: 0.1, note_slide: 0.01
    sleep 1
    dsh2 = synth :dark_sea_horn, note: notes[2], decay: s-1, cutoff: 50, amp: 0.1, note_slide: 0.01
    sleep 1
    dsh3 = synth :dark_sea_horn, note: notes[0], decay: s-2, cutoff: 50, amp: 0.1, note_slide: 0.01

    if notes.length > 4
      dsh4 = synth :dark_sea_horn, note: notes[-1], decay: s-2, cutoff: 80, amp: 0.1, note_slide: 0.01
    end
  end

  (s-2).times{
    sleep 1
    #control dsh, note: scale(:fs3, :minor_pentatonic, num_ocatives: 2).shuffle.choose
  }
end

live_loop :cracklin do
  with_fx(:pitch_shift, time_dis: 0.9) do
    sample_and_sleep Mountain[/cracklin/], rate: 0.9, amp: 0.1, cutoff: 60
  end
end

#shader :iForm, 1.0
#shader :iDistort, 1.0
#shader :iMotion, 0.01

live_loop :snap, sync: :warm do
  sleep 2
  with_fx(:bitcrusher, mix: 0.1, bits: range(8,16,1).tick(:bits)) do
    with_fx(:reverb, room: 1.0, mix: 0.9, damp: 0.5) do |r_fx|
      #shader :decay, :iForm, rrand(0.1, 0.5), 0.001
      #shader :decay, :iMotion, rrand(0.003, 0.005), 0.00001
      # sample Fraz[/snap/,0], cutoff: 70, amp: 0.5
    end
  end
  #shader :iDistort, rrand(0.001, 0.05)
  sleep 2
end

live_loop :heart, sync: :warm do
  # shader :decay, :iKick, 1.0
  # shader :decay, :iBeat, 1.0
  #  sample Fraz[/kick/,[0,0]].tick(:sample), cutoff: 50
  sample Fraz[/interference/,/c#/,0], amp: 0.01, beat_stretch: 16
  sleep 4
end
