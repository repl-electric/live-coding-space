#             _                   \:o/     π=-      π=-
#_|_ o  _  __(_| _  ___|_ _ __     █       π=-   π   π=-   π=
# |_ | (/_ | __|(_| |  |_(/_| |  .||.     π=-  π=-  π=-
#
["support", "soprano", "samples"].each{|f| require "/Users/josephwilk/Workspace/repl-electric/sonic-pi/lib/#{f}"}
clacker_dur   = sample_duration(S.clacker)
beat_dur      = sample_duration(S.beat)
halixic_dur   = sample_duration(S.halixic)
eery_ratio    = sample_duration(S.eery_vocals) / beat_dur
clacker_ratio = sample_duration(S.clacker) / beat_dur

bar    = beat_dur / 4.0
half   = beat_dur / 2.0
eighth = beat_dur / 8.0
quart  = beat_dur / 16.0

live :wail do |n|
  sync :beat
  sleep bar*2
  with_fx :pan, pan: Math.sin(n) do
    with_fx :rlpf do
      with_fx :ixi_techno, phase: bar do
        sample [S.sixg, S.sixa, S.sixd].choose, rate: [eery_ratio].choose, amp: 0.07, pan: [0.1, -0.1].choose
      end
    end
  end
end

live :dark_snares do
  with_fx :reverb do
    sync :the_snare
    sample S.drum_2, amp: 0.4
    sync :the_snare
    sample S.drum_2, amp: 0.5
  end
end

live :beat do |n|
  tempo = [60*2].choose
  drum_cutoff =  n % 4 < 3 ? 80 : 85
  with_fx :lpf, cutoff: lambda{ 0 }  do
    with_bpm tempo do
      sleep_rate = 2.0
      sample S.drum_2
      if n % 4 == 1
        sample :drum_heavy_kick, rate: 0.8
        sleep (beat_dur/sleep_rate)
        with_fx :reverb do
          sample S.eery_vocals, start: 0.1, finish: 0.15, amp: 5, rate: eery_ratio/4.0
        end
        sample :drum_heavy_kick, rate: 0.7
        cue :the_snare
        sleep (beat_dur/sleep_rate)
        cue :the_snare
      else
        drum_rate = n % 4 == 0 ? 0.7 : 0.8
        sample :drum_heavy_kick, rate: drum_rate
        with_fx :rlpf do
          sleep beat_dur/sleep_rate
          cue :the_snare
          sleep beat_dur/sleep_rate
          cue :the_snare
        end
      end

    end
  end
end

live :quiet_ambience do
  sync :beat
  sleep beat_dur*3
  sample :ambi_choir, rate: 0.2, amp: 0.2
end

live :dark_rolling do
  sync :beat
  with_fx :reverb do
    sample S.zoom, amp: 0.2
    sleep beat_dur
  end
end

eery_slicing_phase = [eery_ratio].choose
live :mountain_beats do |n|
  vol = 1.0
  rate = n % 8 >= 4 ? eery_ratio/2.0 : -(eery_ratio/2.0)
  sync :beat

  if n % 4 == 0
    eery_slicing_phase = [beat_dur/4.0, eery_ratio].choose
  end

  #with_fx :slicer, phase: lambda{eery_slicing_phase} do sample S.eery_vocals, rate: rate, amp: vol+0.2 end
  #with_fx :lpf, cutoff: 100 do  sample S.eery_vocals, rate: eery_ratio/4.0, amp: vol end
  sample S.eery_vocals, rate: (eery_ratio/4.0), amp: vol
  #sample S.eery_vocals, rate: (eery_ratio/8.0), amp: vol
  #sample S.eery_vocals, rate: -(eery_ratio/4.0), amp: vol

  sleep sample_duration(S.eery_vocals)
end

live :depths_voices do |n|
  sync :beat
  rate = [0.7, -0.7].choose
  fxs =[:echo, :reverb, :reverb, :reverb, :reverb, :lpf]
  with_fx fxs.choose do
    sample S.whisper, amp: 1.0, rate: rate, attack_level: 0.0
  end

  sleep beat_dur

  #POWER LIES HERE
  if n % 4 == 0
    with_fx :echo do
      with_fx :reverb do
        sample S.eery_vocals, start: 0.0, finish: 0.1, amp: 2.5, rate: eery_ratio/2.0
      end
    end
  end
  #sample S.whisper, start: 0.2, finish: 1.0, rate: 1, amp: 1
end

live :floating_voices do |n|
  if n % 4 == 2
    with_fx :echo do
      sync :beat
      with_fx :compressor do
        ratio = [1.5, 1.8, 0.5].choose
        with_fx :slicer, phase: eery_ratio, pulse_width: 0.9 do
          r = eery_ratio/ratio
          with_fx :pan, pan: lambda{rrand(-1,1)}  do
            sample S.ethereal_femininity, amp: 0.25, rate: r, attack_level: 0.9
          end
          r = (eery_ratio/1.8) - 0.01
          with_fx :pan, pan: lambda{rrand(-1,1)}  do
            sample S.ethereal_femininity, amp: 0.2, rate: r, attack_level: 0.9
          end
          r = eery_ratio/ratio
          with_fx :pan, pan: lambda{rrand(-1,1)}  do
            sample S.ethereal_femininity, amp: 0.25, rate: r, attack_level: 0.9
          end
        end
      end
    end
  end
  sleep sample_duration(S.ethereal_femininity)
end

live :whispering_wind do
  with_fx :echo do
    with_fx :lpf do
      s = S.whisper
      pan_amps = [[0.6, 0.55, 0.4], [0.6, 0.55, 0.4].reverse].choose
      pan_dir = [[1, 0.0, -1], [-1, 0, 1]].choose

      sync :beat
      sleep eery_ratio/4.0
      sample s, rate: -1.0, pan: pan_dir[0], amp: pan_amps[0]
      sleep 1
      sample s, rate: 1.0, pan: pan_dir[1], amp:  pan_amps[1]
      sleep 1
      sample s, rate: -1.0, pan: pan_dir[2], amp:  pan_amps[2]
      sleep  beat_dur*4
    end
  end
end

live :mountain_voices do |n|
  sync :beat
  vol = 0.5
  if n % 4 == 1
    with_fx :echo, decay: beat_dur, phase: (quart+(bar/2.0))  do
      with_fx :reverb do
        rates = [
          #[eery_ratio/1.5, eery_ratio/1.5, eery_ratio],
          [beat_dur/4.0,beat_dur/2.0]
        ]

        sample S.eery_vocals, start: 0.4, finish: 0.5, amp: 1,
          rate: rates.choose.choose

        #ah_candidate = [Sop.ahp].choose.choose
        #with_fx :slicer, phase: quart do
        #  sample ah_candidate, rate: eery_ratio, pan: -0.25, release: 0.01, decay: 0.01
        #end

        #If we are feeling *brave*, lets try some overlap
        #sleep beat_dur/2.0
        #with_fx :slicer, phase: [quart/2, quart].choose  do
        #  sample ah_candidate, rate: eery_ratio/[1.5, 2.0].choose, pan: 0.25, release: 0.01, decay: 0.01
        #end
      end
    end
  end
end

#IN THE BEGINNING
begone :whispering_wind
begone :mountain_voices
begone :floating_voices
begone :dark_snares
begone :depths_voices
begone :mountain_beats
begone :dark_rolling
begone :quiet_ambience
begone :wail

set_volume! 1.25
#solo(:lead)
#fadeout
