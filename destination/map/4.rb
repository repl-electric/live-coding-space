_=nil
with_fx(:reverb, room: 0.9, mix: 0.8) do
  live_loop :a do
    4.times{ sync :apeg}
    notes = (knit
             #    chord(:Fs3, "M")[1..-1], 7,  #F A C
             #   chord(:Fs3, 'maj9')[0..-1], 1,  #
             #  chord(:As3, 'M')[1..-1], 8,  # A C E
             # chord(:Ds3, "m")[1..-1], 8,  # D F A

             chord_degree(1, :fs3, :major)[0..-1], 4,
             chord_degree(3, :fs3, :major)[0..-1], 4,
             chord(:Ds3, "m")[0..-1], 4,

             chord(:Fs3, 'sus4')[0..-1], 4,
             chord(:As3, 'm+5')[0..-1], 4,
             chord(:Ds3, "m7")[0..-1], 4,   #D F A C

             chord(:Fs3, 'sus4')[0..-1], 4,
             chord(:As3, 'm+5')[0..-1], 4,

             chord(:Cs3, :M)[0..-1], 2,
             chord(:Cs3, :maj9)[0..-1],2
             )

    with_transpose(-12) do
      with_synth(:dark_sea_horn) do
        play (knit _,3 , notes.tick(:a, offset:1)[-1],1).tick(:r),
          release: 8.0, sustain:2.0, decay: 8.0, amp: 0.2,
          attack: 1.0
      end
    end
  end
end
