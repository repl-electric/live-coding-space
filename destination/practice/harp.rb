use_bpm 80
live_loop :intro do
  #sample CineElec[/80_F#m_MelodicHarp/,[0,0]].tick(:sample), cutoff: 130, amp: 0.5, beat_stretch: 16
  sleep 16
end

live_loop :thing do
  #sample CineElec[/cello/, /F#m/,0..3].tick, cutoff: 135
  with_fx :slicer, phase: 0.25, invert_wave:0 do |s|
    sample CineElec[/cello/, /F#m/,0..3].tick, cutoff: 60
    8.times {sleep 1.0; control s, phase: (ring
                                           0.5, 0.25, 0.25, 0.5,
                                           0.5, 0.25, 0.125, 0.5).tick(:phase)
             with_fx(:reverb, room: 0.6, mix: 0.6, damp: 0.5) do |r_fx|
               sample CineElec[/angelcall/,0..4].tick(:sample), cutoff: (range 60,130,5).tick(:r), amp: 0.5
             end
             }
  end
end

live_loop :asdasd, sync: :intro do
  #sample CineElec[/80/,/F#m/,2], beat_stretch: 16, amp: 2.0, cutoff: 130
  with_fx(:slicer, phase: 0.25, probability: 0) do
    #sample CineElec[/80/,/F#m/,2], beat_stretch: 16, amp: 2.0, cutoff: 130, rate: -1.0
  end

  with_fx(:slicer, phase: 0.5, probability: 0, invert_wave: 1) do
    #sample CineElec[/80/,/F#m/,2], beat_stretch: 16, amp: 2.0, cutoff: 130, rate: 1.0
  end

  #synth :dsaw, note: chord(:Fs3, :m), cutoff: 70, decay: 4.0, detune: 12, amp: 1.0
  with_fx(:krush, mix: 0.1) do |r_fx|
    #   sample CineElec[/80/,/F#m/,2], beat_stretch: 16, amp: 0.25, cutoff: 80, rate: 1.0, rate: 0.5
  end

  with_fx(:slicer, phase: 0.5, probability: 0, invert_wave: 1) do
    with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
      with_fx(:distortion) do
        #        sample CineElec[/80/,/F#m/,2], beat_stretch: 16, amp: 1.0, cutoff: 130, rate: 1.0
      end
    end
  end
  sleep 16
end
_=nil
live_loop :bass do
  d = (knit
       chord(:A1, :M) ,1, _, 15,
       chord(:Cs2, :m),1, _, 15,
       chord(:A2, :M) ,1, _, 15,
       chord(:Fs2, :m),1, _, 15).tick(:n)
  if d
    #synth :tb303, note: d[0], cutoff: 60, decay: 4.0
    #synth :dark_sea_horn, note: d, cutoff: 60, decay: 8.0,attack: 0.00001
  end

  with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
    with_fx(:distortion, mix: 0.5) do
      synth :hollow, note: (knit
                            :A3, 16,
                            :CS3, 16,
                            :A3, 16,
                            :Cs3, 16).tick(:d), release: 0.25/2.0, amp: 10.0*0
    end
  end
  sleep 1/2.0
end

live_loop :pad do
  #sample CineElec[/f#m_ColdPad/].tick(:sample), cutoff: 130, amp: 2.0
  sleep 16
end

live_loop :perc_added do
  with_fx(:slicer, phase: 0.25*2, probability: 0, mix: 0.0) do
    #sample CineElec[/80_OrganicPercs/,6], cutoff: 100, amp: 1.0, beat_stretch: 16
  end
  sleep 16
end

live_loop :kickit, sync: :intro do
  #sample CineElec[/kick/,[0,3]].tick(:sample), cutoff: 130, amp: 2.5
  sleep 1
  #sample CineElec[/kick/,[1,2]].tick(:sample), cutoff: 120, amp: 2.5
  with_fx(:slicer, phase: (ring 0.25, 0.5, 0.5, 0.25).tick, probability: 0) do
    with_fx(:reverb, room: 0.6, mix: 0.5, damp: 0.5) do |r_fx|
      #   sample CineElec[/snare/,[1,1]].tick(:sample), cutoff: 100, amp: 1.5
    end
  end
  sleep 1
end
