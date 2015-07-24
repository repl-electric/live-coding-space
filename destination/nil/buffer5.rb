_=nil
bar = 1.0
live_loop :bellz do
#1.times{sync :foo}
with_fx :distortion, amp: 0.8, mix: 0.3 do
with_synth :beep do
with_fx (knit :reverb,2).tick(:fx), decay: (knit 4.0,7, 8.0,1).tick(:de), room: 1.0 do |fx_verb|
  n = play (knit :Fs5, 1, :Fs4, 1, :Fs5, 1, :Fs4, 3, _, 1,
                 :Fs4, 7, _, 1,
                 :Cs4, 7, _, 1,
                 :Ds4, 7, _, 1,
                 :As4, 7, _, 1,
                 :Es4, 7, _, 1,
).tick, amp: 0.3

  if dice(32) == 1
     with_fx :pan, pan: Math.sin(vt*13)/1.5 do
     with_fx :bitcrusher, bits: 7, sample_rate: 32000 do
     #  sample Mountain[/bow/i, /f#/i, 0],amp: 0.4
  end;end;end

  if (knit :echo,2, :reverb,2).look(:fx) == :reverb
   control fx_verb, damp: rrand(0.0,1.0)
  end
  sleep bar/4.0
  control n, note: (knit :As4, 4, :B4, 4,
                         :Cs4, 4, :B4, 4).tick


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


end;end;end;end