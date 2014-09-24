define :csample do |name|
  root = "/Users/josephwilk/Dropbox/repl-electric/samples/pi"
  "#{root}/#{name}"
end

halixic_s             = csample "halixic.wav"
clacker_s             = csample "clacker_rhythm.wav"
eery_vocals_s         = csample "hypnoticsynth.wav"
zoom_s                = csample "nano_blade_loop.wav"
beat_s                = csample "crunchy_beat.aif"
whisper_s             = csample "whisperloop.wav"
ethereal_femininity_s = csample "ethereal_femininity.wav"
sixg_s                = csample "120bpmacantholabrus6s_g.wav"
sixa_s                = csample "120bpmacantholabrus6s_a.wav"
sixd_s                = csample "120bpmacantholabrus6s_d.wav"
fourg_s               = csample "120bpmacantholabrus4s_g.wav"
h_s                   = csample "120bpm2smagnhildhh.wav"
d_s                   = csample "120bpm2smagnhildbd.wav"
feedback_s            = csample "feedback21.wav"
#fourg_s = csample "120bpmabramis4s_g.wav"

clacker_dur = sample_duration(clacker_s)
beat_dur    = sample_duration(beat_s)
halixic_dur = sample_duration(halixic_s)

define :backing_highlights do
  #sample [sixg_s, sixa_s, sixd_s].choose, rate: [1/2.0, 1/4.0, 1/8.0].choose
  sample halixic_s, rate: 0.2
  sample halixic_s

  if dice(6) > 3
    with_fx :slicer  do
      options = [2.0, 1.0 -2.0, -1.0]
      sample halixic_s, rate: options.choose
      sleep 1
      sample halixic_s, rate: options.choose
      sleep 0.5
      sample halixic_s, rate: options.choose
      sleep 0.5
      sample halixic_s, rate: options.choose
      sleep 1
    end
    sleep halixic_dur-2-1
  else
    sleep halixic_dur
  end

end

define :backing_melody do
  sample halixic_s, rate: 1
  with_fx :reverb, room: 0.5  do
    sample halixic_s, rate: 0.5
  end
  with_fx :echo, mix: lambda{rrand(0, 1)} do
    sample halixic_s, rate: 1.01, amp: 0.5
    sleep halixic_dur
  end
end

define :drums do
  with_fx :reverb do
    sync :the_snare
    sample :drum_snare_soft, rate: 0.45, amp: 0.7
  end
end

define :drums2 do
  # default tempo is 60 bpm
  tempo = [60/2.0, 60, 60*2, 60*4].choose
  with_bpm tempo do
    sample :drum_heavy_kick, rate: 0.8
    sleep_rate = 2.0
    
    if tempo == 60
      sleep beat_dur/sleep_rate
      cue :the_snare   
      sleep beat_dur/sleep_rate
      cue :the_snare
    else
      sleep beat_dur/sleep_rate*2.0
    end
    
    with_fx :rlpf do
      sample beat_s, pan: lambda{rrand(-1,1)}
    end
  end
end

define :ambience do
  sleep halixic_dur*3
  sample :ambi_choir, rate: 0.2, amp: 0.2
end

define :zoom do
  with_fx :reverb do
    sample zoom_s
    sleep halixic_dur*4
  end
end

define :glitch do
  with_fx :ixi_techno do
    sample clacker_s
    sleep clacker_dur
  end
end

define :eery_vocals do
  rate = [1, -1].choose
  if dice(6) > 4
    sample eery_vocals_s, rate: rate
    sleep sample_duration(eery_vocals_s)
  end
end

define :deeper_vocals do
  rate = [0.7, -0.7].choose
  fxs =[:slicer, :echo, :reverb, :reverb, :reverb, :reverb, :lpf]
  with_fx fxs.choose do
    sample whisper_s, amp: 1, rate: rate, attack_level: 0.0
  end
  sleep clacker_dur
end

define :ethereal do
  with_fx :pan, pan: lambda{rrand(-1,1)}  do
    with_fx :echo do
      with_fx :reverb, mix: 0.9 do
        r = [1, 1/2.0, 1/4.0, 1/8.0].shuffle.first
        sample ethereal_femininity_s, amp: 0.9, rate: r, attack_level: 0.9
      end
    end
  end

  sleep clacker_dur
end

in_thread(name: :a1) { loop {ambience} }
in_thread(name: :d1) { loop {drums   } }
in_thread(name: :d2) { loop {drums2  } }

in_thread(name: :g1) { loop {glitch} }
in_thread(name: :z1) { loop {zoom}   }

in_thread(name: :b1) { loop {backing_melody}     }
in_thread(name: :h3) { loop {backing_highlights} }

in_thread(name: :e1)  { loop {eery_vocals}   }
in_thread(name: :de1) { loop {deeper_vocals} }
in_thread(name: :e2)  { loop {ethereal}      }

#set_volume! 1

define :fadeout do
vol = 1
while(vol >= 0) do
  set_volume! vol
  vol -= 0.08
  sleep 1
end
end

#fadeout
