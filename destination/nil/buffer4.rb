## Instruments
bar = 1.0

define :i_float do |note, *opts|
  defaults = {cutoff: 70, attack: 0.01, pan: (Math.sin(vt*13)/1.5), amp: 0.5, decay: 0.1 + rrand(0.1,0.2), release: (ring 1.0,0.25,0.4,0.25).tick(:dasd)}
  defaults = defaults.merge(opts[0]||{})
  with_synth(:prophet){play note, defaults}
end

define :i_int do |note, *opts|
  defaults = {pan: (Math.sin(vt*13)/1.5), amp: (ring 0.25).tick(:sdf), decay: 0.1 + rrand(0.1,0.2),
                    release: 0.3} #, release: (ring 1.0,0.25,0.4,0.25).tick(:dasd)}
  defaults = defaults.merge(opts[0]||{})
  with_synth(:beep){play note, defaults}
end


define :i_bass do |note, *opts|
  defaults = {
        cutoff: 60, res: 0.5,
        release: (knit 2.5*bar,10, 8.0*bar,1,    5.0*bar,2,     5.0*bar,1, 2.5*bar,1, 2.5*bar,1).tick(:sd),
        attack:  (knit 0.01,10,    0.15,1,        0.15,2,        0.25,1,    0.25,1,     0.01,1,).tick(:att),
        amp:     (knit 0.5,13, 0.2, 3).tick(:ampe)}
  defaults = defaults.merge(opts[0]||{})
  with_transpose(12) do
    with_synth(:beep) do
      play note, defaults
    end
  end

  defaults = {
    amp: 1.0, release: (knit 2.01*bar, 9, 8.02*bar, 2, 2.1*bar,5).tick(:Bass), 
    attack: 0.05, cutoff: 60,  res: 0.5}
  defaults = defaults.merge(opts[0]||{})
  with_transpose(0) do
    with_synth :beep do
      play note, defaults
    end
  end
end

define :i_deter do |note1, note2, *opts|
  opts = opts[0] || {}
  defaults = {amp: 0.3}
  s = opts[:synth] || :beep
  d = opts[:mix]   || 0.3
  fx_pattern  = opts[:fx_pattern] || (knit :echo,2, :reverb,2)
  distort_amp = opts[:distort_amp] || 0.8
  
  damp_time = opts[:damp_time] || bar/4.0

  opts.delete(:fx_pattern)
  opts.delete(:distory_amp)
  opts.delete(:damp_time)

  werble = if opts[:werble] != nil
    opts[:werble]
  else
    true
  end

  defaults = defaults.merge(opts)
  with_fx :distortion, amp: distort_amp, mix: d do
    with_synth(s) do
      with_fx fx_pattern.tick(:fx), decay: 4.0, room: 1.0 do |fx_verb|
        active_synth = play note1, defaults
        sleep damp_time
        control(active_synth, note: note2) if werble

        2.times{
          sleep damp_time
          if fx_verb.name =~ /reverb/
            control fx_verb, damp: rrand(0.0,1.0)
          end
        }
      end
    end
  end
end
define :i_nil do |n, *opts|
  defaults = {release: 2.0, amp: 2.0}
  defaults = defaults.merge(opts[0]||{})
  with_synth(:hollow) do
  with_fx :pitch_shift, pitch_dis: 0.001, time_dis: 0.1, window_size: 1.5  do
    play n, defaults
  end
  end
end
