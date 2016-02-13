use_bpm 80
live_loop :intro do
  sample CineElec[/80_F#m_MelodicHarp_SP_01/,[0,0]].tick(:sample), cutoff: 130, amp: 0.5, beat_stretch: 16
  sleep 16
end

live_loop :asdasd, sync: :intro do
  sample CineElec[/80/,/F#m/,2], beat_stretch: 16, amp: 2.0
  sleep 16
end
_=nil
live_loop :bass do
  d = (knit
       :A1,1, _, 15,
       :Cs1,1, _, 15,
       :A2,1, _, 15,
       :Fs2,1, _, 15).tick(:n)
  if d
    synth :tb303, note: d, cutoff: 60, decay: 4.0
    synth :dark_sea_horn, note: d, cutoff: 60, decay: 8.0
  end

  with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
    with_fx(:distortion, mix: 0.5) do
      synth :hollow, note: (knit
                            :A3, 16,
                            :CS3, 16,
                            :A3, 16,
                            :Cs3, 16).tick(:d), release: 0.25/2.0, amp: 10.0
    end
  end
  sleep 1/2.0
end

live_loop :kickit, sync: :intro do
  sample CineElec[/kick/,[0,0]].tick(:sample), cutoff: 100, amp: 2.5
  sleep 1

  with_fx(:slicer, phase: (ring 0.25, 0.5, 0.5, 0.25).tick, probability: 0) do
    with_fx(:reverb, room: 0.6, mix: 0.5, damp: 0.5) do |r_fx|
      sample CineElec[/snare/,[1,1]].tick(:sample), cutoff: 100, amp: 0.5
    end
  end
  sleep 1
end
