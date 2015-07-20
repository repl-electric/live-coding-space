## Instruments
define :i_float do |note|
  with_synth(:prophet){play note, cutoff: 70, attack: 0.01, pan: (Math.sin(vt*13)/1.5), amp: 0.5, decay: 0.1 + rrand(0.1,0.2), release: (ring 1.0,0.25,0.4,0.25).tick(:dasd)}
end

define :i_int do |note|
  with_synth(:beep){play note, pan: (Math.sin(vt*13)/1.5), amp: (ring 0.25).tick(:sdf), decay: 0.1 + rrand(0.1,0.2),
                    release: 0.3} #, release: (ring 1.0,0.25,0.4,0.25).tick(:dasd)}
end

define :i_bass do |note|
  with_transpose(12) do
    with_synth(:beep) do
      play note,
        cutoff: 60, res: 0.5,
        release: (knit 2.5*bar,10, 8.0*bar,1,    5.0*bar,2,     5.0*bar,1, 2.5*bar,1, 2.5*bar,1).tick(:sd),
        attack:  (knit 0.01,10,    0.15,1,        0.15,2,        0.25,1,    0.25,1,     0.01,1,).tick(:att),
        amp:     (knit 0.5,13, 0.2, 3).tick(:ampe)
    end
  end
  with_transpose(0) do
    with_synth :beep do
      play note, amp: 1.0, release: (knit 2.01*bar, 9, 8.02*bar, 2, 2.1*bar,5).tick(:Bass), attack: 0.05, cutoff: 60,  res: 0.5
    end
  end
end

define :i_deter do |note1, note2|
  with_fx :distortion, amp: 0.8, mix: 0.3 do
    with_synth :beep do
      with_fx (knit :echo,2, :reverb,2).tick(:fx), decay: 4.0, room: 1.0 do |fx_verb|
        active_synth = play note1, amp: 0.3
        if dice(32) == 1
          with_fx :pan, pan: Math.sin(vt*13)/1.5 do
            with_fx :bitcrusher, bits: 7, sample_rate: 32000 do
              #sample Mountain[/bow/i, /f#/i, 0],amp: 0.4
        end;end;end
        sleep bar/4.0
        control active_synth, note: note2

        2.times{
          sleep bar/4.0
          if fx_verb.name =~ /reverb/
            control fx_verb, damp: rrand(0.0,1.0)
          end
        }
      end
    end
  end
end