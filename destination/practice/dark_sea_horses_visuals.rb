set_volume! 1.0


live_loop :warm do
  sample Fraz[/interference/,/f#m/].tick(:sample), cutoff: 60, amp: 0.01, beat_stretch: 16
  #shader [:iR, :iB, :iG], rand*1, rand*4, rand*2

  data = (ring
          (chord :FS3, :m),
          (chord :FS3, :m, invert: 1),
          (chord :A3, :M), #major
          (chord :Cs3, :m),
          (chord :D3, :M),
          (chord :E3, :M),

          (chord :FS3, :sus4),
          (chord :A3, :M, invert: -1), #major
          (chord :A3, :M), #major
          (chord :Cs3, :m7),
          (chord :D3, :M),
          (chord :E3, :M7)
          )

  notes = data.tick(:main)

  #shader :iForm, rrand(0.3,0.4)

  #lets try some suspension/anticipation.
  #I just learnt this...

  #Grab the next chord not playing yet.
  dis_note = data.look(offset: 1)[2] #unstable note maybe...
  #Try the 2nd note of the chord


  with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
    with_transpose 0 do
      n = notes[0] + (dice(6) > 3 ? 5 : 0)
      #synth :hollow, note: n, attack: 4.0, decay: 4.0, amp: 0.2, cutoff: 80
    end
  end

  at do
    _ = nil
    sleep 6
    with_transpose 0 do
      with_fx(:reverb, room: 1.0, mix: 0.3, damp: 0.5) do |r_fx|
        #synth :dark_ambience, note: (ring dis_note, _, _).tick(:not_always), attack: 0.01, decay: 8.0, amp: 1.0, cutoff: 50
      end
    end

    with_transpose 0 do
      with_fx(:reverb, room: 1.0, mix: 0.3, damp: 0.5) do |r_fx|
        #synth :dark_ambience, note: (ring dis_note, _, _).tick(:not_always), attack: 0.01, decay: 8.0, amp: 1.0, cutoff: 50
      end
    end


  end

  with_fx :pitch_shift, mix: 0.1 do

    with_transpose -24 do
      # bass_dsh =  synth :dark_sea_horn, note: notes[0], decay: 2, cutoff: 130, amp: 0.05, note_slide: 0.01
    end

    # dsh = synth :dark_sea_horn, note: notes[1], decay: 8, cutoff: 60, amp: 0.1, note_slide: 0.01
    sleep 1
    #dsh2 = synth :dark_sea_horn, note: notes[2], decay: 7, cutoff: 50, amp: 0.1, note_slide: 0.01
    sleep 1
    # dsh3 = synth :dark_sea_horn, note: notes[0], decay: 6, cutoff: 50, amp: 0.1, note_slide: 0.01

    if notes.length > 4
      # dsh4 = synth :dark_sea_horn, note: notes[-1], decay: 6, cutoff: 80, amp: 0.1, note_slide: 0.01
    end
  end

  6.times{
    sleep 1
    #control dsh, note: scale(:fs3, :minor_pentatonic, num_ocatives: 2).shuffle.choose
  }
end

live_loop :cracklin do
  with_fx(:pitch_shift, time_dis: 0.9) do
    sample_and_sleep Mountain[/cracklin/], rate: 0.9, amp: 0.4, cutoff: 130
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
  sample Abstract[/perc/,/loop/,[0,0]].tick(:sample), cutoff: 60, amp: 0.5, beat_stretch: 4
  sleep 4
end