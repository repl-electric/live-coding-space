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
bar    = beat_dur / 4.0
half   =  beat_dur / 2.0
eighth = beat_dur / 8.0
quart  = beat_dur / 16.0
voc_s = csample "150399__mikobuntu__voc-formant9.wav"
c13 = csample "c13.aif"
c14 = csample "c14.aif"
c2  = csample "c2.aif"
err_beat_ratio = sample_duration(eery_vocals_s) / beat_dur

live_loop_it :backing_highlights do
  sync :drums
  sample [sixg_s, sixa_s, sixd_s].choose, rate: [1/2.0, 1/4.0, 1/8.0].choose
  sample halixic_s, rate: 0.2
  sample halixic_s
  #  3if dice(6) > 1
  with_fx :slicer  do
    options = [1.0 -1.0]
    sample halixic_s, rate: options.choose
    sleep half
    sample halixic_s, rate: options.choose
    sleep bar
    sample halixic_s, rate: options.choose
    sleep bar
    sample halixic_s, rate: options.choose
    sleep half
  end
end
live_loop_it :backing_melody do
  sync :drums
  #if dice(6) > 3
  sample halixic_s, rate: 1
  with_fx :reverb, room: 0.5  do
    sample halixic_s, rate: 0.5
  end
  with_fx :echo, mix: lambda{rrand(0, 1)} do
    sample halixic_s, rate: 1.01, amp: 0.5
    sleep quart*4
  end
  #end
end
live_loop_it :drums2 do
  with_fx :reverb do
    sync :the_snare
    sample c2, amp: 0.7
    #sample c13
    sync :the_snare
    sample c2, amp: 0.7
  end
end
@cutoff = 250
voice1 = csample "blip.wav"
x  = "/Users/josephwilk/Dropbox/repl-electric/samples/beep.wav"
live_loop :drums3 do
  sync :drums
  with_fx :echo do
    sample voice1, rate: 1.0, amp: 0.2
  end
  sleep beat_dur
end
live_loop_it :drums do |inc|
  tempo = [60*2].choose
  with_fx :lpf, cutoff: lambda{ 120 }  do
    with_bpm tempo do
      sleep_rate = 2.0
      sample :drum_heavy_kick, rate: 0.8
      if sleep_rate == 8.0
        s = [c2].choose
        sample s
      end
      if sleep_rate == 8.0
        sample beat_s, pan: -0.85, rate: [1].choose
        sleep beat_dur/sleep_rate
        sample beat_s, pan: 0.85,  rate: [1].choose
        #        sample c2
        sample c14
        cue :the_snare
        sleep beat_dur/sleep_rate
        sample c14
        cue :the_snare
      else
        with_fx :rlpf do
#          sample beat_s, pan: lambda{rrand(-0.8,0.8)}, rate: [1].choose
          sleep beat_dur/sleep_rate
          cue :the_snare
          sleep beat_dur/sleep_rate
          cue :the_snare
        end
      end
    end
    #  end
  end
end

live_loop_it :ambience do
  #  sync :drums
  sleep halixic_dur*3
  #sample :ambi_choir, rate: 0.2, amp: 0.2
end

live_loop_it :zoom do
  # sync :drums
  with_fx :reverb do
    sample zoom_s
    sleep beat_dur
  end
end

ar = (sample_duration clacker_s) / beat_dur

live_loop_it :glitch do
  sync :drums
  with_fx :ixi_techno, phase: quart do
    #    sample clacker_s, rate: 1, amp: 0.9, pan: [-1, 1].choose
    sleep beat_dur * 2
  end
end

n=0
live_loop :eery_vocals do
  pq = sample_duration(eery_vocals_s) / beat_dur

  sync :drums
  vol = 1.0

  if n % 16
    rate = pq/2.0
  elsif n % 2
    rate = -1 #pq/8.0
  else
    rate = 1
  end
  with_fx(:slicer, phase: lambda{[pq, beat_dur/8, beat_dur/4].choose}) do sample eery_vocals_s, rate: rate,
      amp: vol+0.2 end

  with_fx :lpf, cutoff: 100 do
    sample eery_vocals_s, rate: pq/4, amp: vol
  end
  sample eery_vocals_s, rate: -(pq/4), amp: vol
  sleep sample_duration(eery_vocals_s)

  n += 1
end

live_loop_it :deeper_vocals do |n|
  vol = 2
  #  sync :drums
  rate = [0.7, -0.7].choose
  fxs =[:echo, :reverb, :reverb, :reverb, :reverb, :lpf]
  with_fx fxs.choose do
    sample whisper_s, amp: 2.5, rate: rate, attack_level: 0.0
  end
  
  sleep beat_dur

  #POWER LIES HERE
  if n % 8 == 0
  with_fx :echo do
    with_fx :reverb do
      sample eery_vocals_s, start: 0.0, finish: 0.1, amp: 5, rate: err_beat_ratio/2.0
    end
  end
  end
  #sample whisper_s, start: 0.2, finish: 1.0, rate: 1, amp: 1
end

live_loop_it :ethereal do
  exclude = [1, 1/2.0, 1/4.0]
  with_fx :echo do
    #quart = 4
    with_fx :slicer, phase: 0.95, pulse_width: 0.5 do
      r = 1/4.0
      with_fx :pan, pan: lambda{rrand(-1,1)}  do
        sample ethereal_femininity_s, amp: 1.0, rate: r, attack_level: 0.9
      end

      r = 1/4.0
      with_fx :pan, pan: lambda{rrand(-1,1)}  do
        sample ethereal_femininity_s, amp: 0.8, rate: r, attack_level: 0.9
      end
      r = 1/4.0
      with_fx :pan, pan: lambda{rrand(-1,1)}  do
        sample ethereal_femininity_s, amp: 1.0, rate: r, attack_level: 0.9
      end
    end
  end

  sleep sample_duration(ethereal_femininity_s)
end

live_loop_it :lead do
  with_fx :echo do
    s = whisper_s
    pan_amps = [[1.0, 0.75, 0.5], [1.0, 0.75, 0.5].reverse].choose
    pan_dir = [[1, 0.0, -1], [-1, 0, 1]].choose

    sample s, rate: -1.0, pan: pan_dir[0], amp: pan_amps[0]
    sleep 1
    sample s, rate: 1.0, pan: pan_dir[1], amp:  pan_amps[1]
    sleep 1
    sample s, rate: -1.0, pan: pan_dir[2], amp:  pan_amps[2]
    sleep  beat_dur/2
  end
end

soporano_root = "/Users/josephwilk/Workspace/music/samples/soprano/Samples"
ah1 = "#{soporano_root}/Sustains/Ah p/vor_sopr_sustain_ah_p_01.wav"
ah2 = "#{soporano_root}/Sustains/Ah p/vor_sopr_sustain_ah_p_02.wav"
ah3 = "#{soporano_root}/Sustains/Ah p/vor_sopr_sustain_ah_p_03.wav"
ah4 = "#{soporano_root}/Sustains/Ah p/vor_sopr_sustain_ah_p_04.wav"

what_n = 0
live_loop_it :floating_voices do
  pq = sample_duration(eery_vocals_s) / beat_dur
  sync :drums
  vol = 0.5
  if what_n % 4 == 1
    with_fx :echo, decay: beat_dur, phase: (quart+(bar/2.0))  do
      with_fx :reverb do
        use_synth :prophet
        #sample ah
        sample eery_vocals_s, start: 0.4, finish: 0.5, amp: 2, rate: [pq/1.5, pq/1.5, pq].choose

        ah_candidate = [ah1,ah2,ah3].choose
        with_fx :slicer, phase: quart do
          sample ah_candidate, rate: pq, pan: -0.25, release: 0.01, decay: 0.01
        end
        
        #if we are feeling brave, lets try some overlap
        sleep beat_dur/2.0
        with_fx :slicer, phase: [quart/2, quart].choose  do
          sample ah_candidate, rate: pq/[1.5, 2.0].choose, pan: 0.25, release: 0.01, decay: 0.01
        end
      end
    end
  end
  use_synth :fm

  #play_pattern_timed [:B3,:B3,:B3], [quart/2, quart/2, bar/2], amp: vol, attack: 0.01, release: quart/2.0, decay: quart/2.0
  #sample eery_vocals_s, rate: pq/4, amp: vol*2
  if what_n % 4 != 0
    #    play_pattern_timed [:B3,:B3], [bar/2.0, bar/2.0], amp: vol, attack: 0.1, release: quart, decay: quart
  else
    #   play_pattern_timed [:B3, :B3, :B3], [bar/2.0, bar/4.0, bar/4.0], amp: vol, attack: 0.1, release: bar/4.0, decay: bar/4.0
  end

  #  end
  what_n += 1
end
#silence :waht
s_n = 0
#silence :synths
#silence :synths2
silence :lead
silence :ethereal

#silence :drums3
#silence :drums
#silence :drums2

#silence :deeper_vocals
#silence :eery_vocals
#silence :glitch
silence :zoom
#silence :ambience

silence :backing_highlights
silence :backing_melody

#set_volume! 0
#solo(:lead)
#fadeout
