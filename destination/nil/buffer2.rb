_=nil
bar = 4.0
live_loop :exceptions do
  (knit 1,6, 2,1).tick(:time).times{sync :next}
  with_fx :distortion, amp: 0.8, mix: 0.3 do
    with_synth :beep do
      with_fx (knit :reverb,2).tick(:fx), decay: 4.0, room: 1.0, room_lag: 2.0 do |fx_verb|
        with_transpose([0].choose) do
          n = play (knit :Fs3, 1, :Fs2, 1, :Fs3, 1, :Fs2, 3, _, 1,
                    :Fs2, 7, _, 1,
                    :Cs2, 7, _, 1,
                    :Ds2, 7, _, 1,
                    :As2, 7, _, 1,
                    :Es2, 7, _, 1,

                    ).tick, amp: 0.3

          with_transpose(0) do
            with_synth(:beep){
              play (knit :Fs4, 1, :Fs4, 1, :Fs4, 1, :Fs4, 3, _, 1,
                    :Fs4, 7, _, 1,
                    :Cs4, 7, _, 1,
                    :Ds4, 7, _, 1,
                    :As4, 7, _, 1,
                    :Es4, 7, _, 1,).tick, amp: 0.2, attack: 0.01, cutoff: 60, res: 0.5, detune: 0.0
            }
          end

          if (knit :echo,2, :reverb,2).look(:fx) == :reverb
            control fx_verb, damp: rrand(0.0,1.0)
          end
          sleep bar/4.0

          control n, note: (knit :As4, 4, :B4, 4, :Cs4, 4, :B4, 4).tick

          if (knit :echo,2, :reverb,2).look(:fx) == :reverb
            control fx_verb, damp: rrand(0.0,1.0)
          end

          sleep bar/4.0

          if (knit :echo,2, :reverb,2).look(:fx) == :reverb
            control fx_verb, damp: rrand(0.0,1.0)
          end

          sleep bar/4.0
          if (knit :echo,2, :reverb,2).look(:fx) == :reverb
            control fx_verb, damp: rrand(0.0,1.0)
          end
        end
      end
    end
  end
end