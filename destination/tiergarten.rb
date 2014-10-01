require "/Users/josephwilk/Workspace/repl-electric/sonic-pi/lib/support"

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

#house_lead_s           = csample "128-bpm-house-lead-fx.wav"
nasal_s = csample "183669__alienxxx__loop2-009-nasal-120bpm.wav"
arp_s = csample "20341__djgriffin__trippyarp120bpm.aif"

epsilon_four_s  = csample "249178__gis-sweden__120bpmepsilon4s-g.wav"
epsilon_six_s  = csample "249177__gis-sweden__120bpmepsilon6s-d.wav"
meta_six_s = csample "249179__gis-sweden__120bpmeta6s-g.wav"
skappa_s = csample "249870__gis-sweden__120bpm10skappa-g.wav"
#fourg_s = csample "120bpmabramis4s_g.wav"

clacker_dur = sample_duration(clacker_s)
beat_dur    = sample_duration(beat_s)
halixic_dur = sample_duration(halixic_s)

live_loop :backing_highlights do
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

live_loop :backing_melody do
  sample halixic_s, rate: 1
  with_fx :reverb, room: 0.5  do
    sample halixic_s, rate: 0.5
  end
  with_fx :echo, mix: lambda{rrand(0, 1)} do
    sample halixic_s, rate: 1.01, amp: 0.5
    sleep halixic_dur
  end
end

live_loop :drums2 do
  with_fx :reverb do
    sync :the_snare
    sample :drum_snare_soft, rate: 0.45, amp: 0.7
  end
end

live_loop :drums do
  # default tempo is 60 bpm
  tempo = [60*2].choose
  with_bpm tempo do
    sample :drum_heavy_kick, rate: 0.8
    sleep_rate = 2.0

    if tempo == 60
      sleep beat_dur/slee_rate
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

live_loop :ambience do
  sleep halixic_dur*3
  sample :ambi_choir, rate: 0.2, amp: 0.2
end

live_loop :zoom do
  with_fx :reverb do
    sample zoom_s
    sleep halixic_dur*4
  end
end

live_loop :glitch do
  with_fx :ixi_techno do
    sample clacker_s
    sleep  beat_dur*2
  end
end

live_loop :eery_vocals do
in_thread(name: :d2) { loop {drums2  } }
  rate = [1, -1].choose
#  if dice(6) > 4
 #   with_fx :slicer do sample eery_vocals_s, rate: rate end
    sample eery_vocals_s, rate: rate, amp: 1.3
    sleep sample_duration(eery_vocals_s)
 # end
end

define :deeper_vocals do
  rate = [0.7, -0.7].choose
  fxs =[:slicer, :echo, :reverb, :reverb, :reverb, :reverb, :lpf]
  with_fx fxs.choose do
    sample whisper_s, amp: 1, rate: rate, attack_level: 0.0
  end
  sleep clacker_dur
end

live_loop :ethereal do
  exclude = [1, 1/2.0, 1/4.0]
  with_fx :echo do
    with_fx :slicer, phase: [0.95, 0.01].choose, pulse_width: 0.6 do
      r = ([1, 1/2.0, 1/4.0, 1/8.0]-exclude).shuffle.first
      with_fx :pan, pan: lambda{rrand(-1,1)}  do
        sample ethereal_femininity_s, amp: 0.9, rate: r, attack_level: 0.9
      end

      r = ([1, 1/2.0, 1/4.0, 1/8.0]-[r]- exclude).shuffle.first
      with_fx :pan, pan: lambda{rrand(-1,1)}  do
        sample ethereal_femininity_s, amp: 0.9, rate: r, attack_level: 0.9
      end

      r = ([1, 1/2.0, 1/4.0, 1/8.0]-[r] - exclude).shuffle.first
      with_fx :pan, pan: lambda{rrand(-1,1)}  do
        sample ethereal_femininity_s, amp: 0.9, rate: r, attack_level: 0.9
      end
    end
  end

  sleep sample_duration(ethereal_femininity_s)
end

live_loop :lead do
  with_fx :echo do
    s = whisper_s
    pan_amps = [[1.0, 0.75, 0.5], [1.0, 0.75, 0.5].reverse].choose
    pan_dir = [[1, 0.0, -1], [-1, 0, 1]].choose

    sample s, rate: 1.0, pan: pan_dir[0], amp: pan_amps[0]
    sleep 1/2.0
    sample s, rate: 1.0, pan: pan_dir[1], amp:  pan_amps[1]
    sleep 1/2.0
    sample s, rate: 1.0, pan: pan_dir[2], amp:  pan_amps[2]
    sleep  beat_dur*8 - (1/2.0)*2
  end
end

silence :lead
silence :ethereal

silence :drums
silence :drums2

silence :deeper_vocals
silence :eery_vocals
silence :glitch
silence :zoom
silence :ambience

silence :backing_highlights
silence :backing_melody

#set_volume! 1
#solo(:lead)
#fadeout
