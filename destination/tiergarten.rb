require "/Users/josephwilk/Workspace/repl-electric/sonic-pi/lib/support"
soporano_root = "/Users/josephwilk/Workspace/music/samples/soprano/Samples"
sop_ah1_s = "#{soporano_root}/Sustains/Ah p/vor_sopr_sustain_ah_p_01.wav"
sop_ah2_s = "#{soporano_root}/Sustains/Ah p/vor_sopr_sustain_ah_p_02.wav"
sop_ah3_s = "#{soporano_root}/Sustains/Ah p/vor_sopr_sustain_ah_p_03.wav"
sop_ah4_s = "#{soporano_root}/Sustains/Ah p/vor_sopr_sustain_ah_p_04.wav"
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
#house_lead_s         = csample "128-bpm-house-lead-fx.wav"
nasal_s               = csample "183669__alienxxx__loop2-009-nasal-120bpm.wav"
arp_s                 = csample "20341__djgriffin__trippyarp120bpm.aif"
epsilon_four_s        = csample "249178__gis-sweden__120bpmepsilon4s-g.wav"
epsilon_six_s         = csample "249177__gis-sweden__120bpmepsilon6s-d.wav"
meta_six_s            = csample "249179__gis-sweden__120bpmeta6s-g.wav"
skappa_s              = csample "249870__gis-sweden__120bpm10skappa-g.wav"
#fourg_s              = csample "120bpmabramis4s_g.wav"
voc_s                 = csample "150399__mikobuntu__voc-formant9.wav"
drum_13_s             = csample "c13.aif"
drum_14_s             = csample "c14.aif"
drum_2_s              = csample "c2.aif"
gutteral_wobble_s     = csample "blip.wav"

clacker_dur   = sample_duration(clacker_s)
beat_dur      = sample_duration(beat_s)
halixic_dur   = sample_duration(halixic_s)
eery_ratio    = sample_duration(eery_vocals_s) / beat_dur
clacker_ratio = (sample_duration clacker_s) / beat_dur

bar    = beat_dur / 4.0
half   = beat_dur / 2.0
eighth = beat_dur / 8.0
quart  = beat_dur / 16.0

live_loop_it :backing_highlights do |n|
  sync :drums
  sleep bar*2
  with_fx :pan, pan: Math.sin(n) do
    with_fx :rlpf do
      with_fx :ixi_techno, phase: bar do
        sample [sixg_s, sixa_s, sixd_s].choose, rate: [eery_ratio].choose, amp: 0.1, pan: [0.1, -0.1].choose
      end
    end
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
    sample drum_2_s, amp: 0.7
    #sample c13
    sync :the_snare
    sample drum_2_s, amp: 0.8
  end
end

live_loop :drums3 do
  sync :drums
  with_fx :echo do
    sample gutteral_wobble_s, rate: 1.0, amp: 0.2
  end
  sleep beat_dur
end

live_loop_it :drums do |inc|
  tempo = [60*2].choose
  with_fx :lpf, cutoff: lambda{ 100 }  do
    with_bpm tempo do
      sleep_rate = 2.0
      sample :drum_heavy_kick, rate: 0.8
      if sleep_rate == 8.0
        s = [drum_2_s].choose
        sample s
      end
      if sleep_rate == 8.0
        sample beat_s, pan: -0.85, rate: [1].choose
        sleep beat_dur/sleep_rate
        sample beat_s, pan: 0.85,  rate: [1].choose
        #sample c2
        sample drum_14_s
        cue :the_snare
        sleep beat_dur/sleep_rate
        sample drum_14_s
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
  end
end

live_loop_it :ambience do
  sync :drums
  sleep halixic_dur*3
  sample :ambi_choir, rate: 0.2, amp: 0.2
end

live_loop_it :zoom do
  # sync :drums
  with_fx :reverb do
    sample zoom_s
    sleep beat_dur
  end
end

live_loop_it :glitch do
  sync :drums
  with_fx :ixi_techno, phase: quart do
    #TOOD: Find something to glitch
    # sample clacker_s, rate: 1, amp: 0.9, pan: [-1, 1].choose
    sleep beat_dur * 2
  end
end

live_loop_it :eery_vocals do |n|
  vol = 1.0

  if n % 16
    rate = eery_ratio/2.0
  elsif n % 2
    rate = -1 #pq/8.0
  else
    rate = 1
  end
  sync :drums
  with_fx(:slicer, phase: lambda{[eery_ratio, beat_dur/8, beat_dur/4].choose}) do sample eery_vocals_s, rate: rate, amp: vol+0.2 end
  with_fx :lpf, cutoff: 100 do  sample eery_vocals_s, rate: eery_ratio/4.0, amp: vol end
  sample eery_vocals_s, rate: (eery_ratio/4.0), amp: vol
  #sample eery_vocals_s, rate: (eery_ratio/8.0), amp: vol

  sleep sample_duration(eery_vocals_s)
end

live_loop_it :deeper_vocals do |n|
  vol = 2
  #  sync :drums
  rate = [0.7, -0.7].choose
  fxs =[:echo, :reverb, :reverb, :reverb, :reverb, :lpf]
  with_fx fxs.choose do
    sample whisper_s, amp: 1.0, rate: rate, attack_level: 0.0
  end

  sleep beat_dur

  #POWER LIES HERE
  if n % 8 == 0
    with_fx :echo do
      with_fx :reverb do
        sample eery_vocals_s, start: 0.0, finish: 0.1, amp: 1.2, rate: eery_ratio/2.0
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
        sample ethereal_femininity_s, amp: 0.8, rate: r, attack_level: 0.9
      end

      r = 1/4.0
      with_fx :pan, pan: lambda{rrand(-1,1)}  do
        sample ethereal_femininity_s, amp: 0.8, rate: r, attack_level: 0.9
      end
      r = 1/4.0
      with_fx :pan, pan: lambda{rrand(-1,1)}  do
        sample ethereal_femininity_s, amp: 0.8, rate: r, attack_level: 0.9
      end
    end
  end
  sleep sample_duration(ethereal_femininity_s)
end

live_loop_it :whispers_wind do
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

live_loop_it :floating_voices do |what_n|
  sync :drums
  vol = 0.5
  if what_n % 4 == 1
    with_fx :echo, decay: beat_dur, phase: (quart+(bar/2.0))  do
      with_fx :reverb do
        #use_synth :prophet
        #sample sop_ah1_s
        sample eery_vocals_s, start: 0.4, finish: 0.5, amp: 2, rate: [eery_ratio/1.5, eery_ratio/1.5, eery_ratio].choose

        ah_candidate = [sop_ah1_s,sop_ah2_s,sop_ah3_s].choose
        with_fx :slicer, phase: quart do
          sample ah_candidate, rate: eery_ratio, pan: -0.25, release: 0.01, decay: 0.01
        end

        #If we are feeling *brave*, lets try some overlap
        sleep beat_dur/2.0
        with_fx :slicer, phase: [quart/2, quart].choose  do
          sample ah_candidate, rate: eery_ratio/[1.5, 2.0].choose, pan: 0.25, release: 0.01, decay: 0.01
        end
      end
    end
  end
end

#IN THE BEGINNING
#silence :whispers_wind
silence :ethereal
#silence :floating_voices
silence :drums3
#silence :drums
#silence :drums2
#silence :deeper_vocals
#silence :eery_vocals
#silence :glitch
silence :zoom
#silence :ambience
#silence :backing_highlights
silence :backing_melody

#set_volume! 0
#solo(:lead)
#fadeout
