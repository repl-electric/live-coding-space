beat = 1/2.0
shaker_s = "/Users/josephwilk/Dropbox/repl-electric/samples/pi/250531__oceanictrancer__shaker-hi-hat.wav"
clap_s = "/Users/josephwilk/Dropbox/repl-electric/samples/Analog\ Snares\ \&\ Claps/13\ \ EMT140\ \(3\).wav"
high_hat_s = "/Users/josephwilk/Workspace/music/samples/LOOPMASTERS\ EXCITE_PACK2014/ESSENTIAL_EDM_2/EDM2_SOUNDS_AND_FX/EDM2_Kit_1_HiHat_1.wav"
high_hat2_s = "/Users/josephwilk/Workspace/music/samples/LOOPMASTERS\ EXCITE_PACK2014/ESSENTIAL_EDM_2/EDM2_SOUNDS_AND_FX/EDM2_Kit_1_HiHat_2.wav"
snare2_s = "/Users/josephwilk/Workspace/music/samples/LOOPMASTERS\ EXCITE_PACK2014/ESSENTIAL_EDM_2/EDM2_SOUNDS_AND_FX/EDM2_Kit_1_Clap_\&_Snare_2.wav"
snare2_s = :drum_snare_soft
voice_s = "/Users/josephwilk/Workspace/music/samples/soprano/Samples/Sustains/Ah p/vor_sopr_sustain_ah_p_01.wav"
#kick_s = :drum_heavy_kick
kick_s = "/Users/josephwilk/Workspace/music/samples/salamanderDrumkit/OH/kick_OH_P_2.wav"

def hollowed_synth(n)
  use_synth :hollow
  with_fx :pitch_shift, pitch_dis: 0.001, time_dis: 0.1, window_size: 1.5  do
    #with_fx :slicer, phase: 1/64.0 do
    play n, release: 8, amp: 2
    #end
  end
end

def degrees_seq(pattern, root, s=nil)
  if !s
    s = /[[:upper:]]/.match(root.to_s[0]) ? :major : :minor
  end
  pattern.to_s.split("").map{|d| degree(d.to_i, root, s)}
end

def chord_seq(pattern, root, s=nil)
  if !s
    s = /[[:upper:]]/.match(root.to_s[0]) ? :major : :minor
  end
  pattern.to_s.split("").map{|d| chord_degree(d.to_i, root, s)}
end

def live(name, opts={}, &block)
  idx = 0
  amp = if(opts[:amp])
    opts[:amp]
  else
    1
  end
  x = lambda{|idx|
    with_fx :level, amp: amp do
      block.(idx)
  end}
  live_loop name do |idx|
    x.(idx)
  end
end

live_loop :clock do
  cue :start; cue :beat; cue :half_beat
  sleep beat/2
  cue :half_beat
  sleep beat/2
  cue :half_beat; cue :beat
  sleep beat/2
  cue :half_beat
  sleep beat/2
end

live_loop :clapper do
  with_fx :level, amp: 1.0 do
    32.times{sync :hit}
    sample clap_s, start: 0.2, amp: 0.25
    sync :hit
    sample clap_s, start: 0.1, amp: 0.3
    sync :hit
    sample clap_s, start: 0.09, amp: 0.4
    sync :hit
    sample clap_s, start: 0.04, amp: 0.4
    #    sample clap_s, amp: 0.4, rate: -1.0
  end
end

live_loop :voices do
  with_fx :level, amp: 2.0 do
    sync :atmosphere
    with_fx(:reverb, room: 1.0, damp: 1){with_fx(:reverb, room: 1.0, damp: 1){with_fx(:reverb, room: 1.0, damp: 1){with_fx(:reverb, room: 1.0, damp: 1){with_fx(:reverb, room: 1.0, damp: 1){
    sample voice_s, attack: 1.0, amp: 0.5}}}}}
  end
end

live_loop :heartzz do |k_idx|
  with_fx :level, amp: 0.0 do
    sample :elec_hollow_kick, amp: 5, start: 0.1, finish: 0.2, rate: 0.9
    #if(k_idx%16 > 7)
      #sleep beat/0.5
    #else
      sleep beat*2
    #end

  end
  k_idx+=1
end

r2=0
live_loop :ride do |r|
  with_fx :level, amp: 0.00 do
    sync :half_beat
    sample (ring high_hat_s, high_hat_s,high_hat_s, high_hat2_s)[r2], amp: 0.5, start: 0.01, finish: rand(0.9..1.0)
    #sleep beat
    2.times do
      start = case r%6
      when 0
        0.3
      else
        0.45
      end
      with_fx :reverb do
        sample shaker_s,amp: 0.4, start: start
      end
      sleep beat/2
      sample shaker_s, amp: 0.2, start: 0.3
      r+=1
    end
    r2+=1
  end
end

live_loop :heart do
with_fx :level, amp: 0.0 do
  sync :hit
  sample :elec_hollow_kick, start: 0.2, finish: 0.5
end
end

rate = 1.0
kick_start = 0.05
live_loop :drums do |n|
  cue :hit
  cue :half_hit
  #sample clap_s, rate: 0.1, amp: 0.25
  with_fx(:lpf, cutoff: 30){
  sample kick_s, amp: 2.5, rate: 1, start: kick_start}

  sleep beat/2
  cue :half_hit
  sleep beat/2

  cue :half_hit
  with_fx :level, amp: 0.0 do
    case n%6
    when 0
      with_fx(:slicer, phase: 1.0){with_fx(:echo, phase: beat/4, decay: 0.09){with_fx(:bitcrusher, bits: 5){
      sample snare2_s, amp: 0.8, finish: 1.0}}}
    when 3
      with_fx(:bitcrusher, bits: 5){
      sample snare2_s, amp: 1.15, start: 0.15,  finish: 0.8}
    when 5
      with_fx(:bitcrusher, bits: 6){
      sample snare2_s, amp: 1.1, start: 0.15, finish: 0.9}
    else
      sample snare2_s, start: 0.20, amp: 1.1, rate: 1.0, finish: 0.45
    end
  end
  sleep beat/4
  cue :half_hit

  sleep beat/4
  cue :half_hit

  sleep beat/2
  n+=1
end

def swishing_saw(notes, lpf_fx, beat)
  fuzz = 0
  notes.each_with_index do |n, idx|
    play n
    sync :half_hit
    control lpf_fx, cutoff: (ring 70, 60, 70 ,60, 80, 90,
                                  70, 65, 70 ,65, 85, 95)[idx] - fuzz
    #sleep (ring beat/2, beat/2, beat/2, beat/2, beat/4, beat/4)[idx]
  end
end

live_loop :synth do |z|
  with_fx :level, amp: 1.0 do
    # sync :beat
    use_synth :dsaw
    use_synth_defaults detune: 0.1, amp: 0.25, attack: 0.001, release: 0.25, note_slide: 1.0
    with_fx :bitcrusher, bits: 12 do |bit_fx|
      with_fx :lpf, cutoff: 70 do |lpf_fx|
        rate = 1.0
        kick_start = 0.01
        sync :hit

        octave = 1

        my = play degrees_seq(112222222222222, :"Cs#{octave}"), amp: 0.1, release: (beat/2)*18*3, attack: 2
        control bit_fx, bits: 12
        control lpf_fx, cutoff: 70
        control my, note: degrees_seq(2, :"Cs#{octave}")[0], detune: 0.1

        with_fx :pitch_shift, pitch_dis: 0.001, time_dis: 0.01, res: 0.001, pitch_slide: 1.0  do |p_fx|

          swishing_saw degrees_seq(222222222222222222, :"Cs#{octave}"), lpf_fx, beat

          sync :hit
          #control my, detune: 0.1
          control bit_fx, bits: 10
          control my, note: degrees_seq(1, :"Cs#{octave}")[0]

          swishing_saw degrees_seq(1111111111111111111, :"Cs#{octave}"), lpf_fx, beat
          sync :hit
          cue :deep_notes

          if(dice(6) >= 85)
            #control my, note: degrees_seq(7, :"Cs#{octave}")[0]
          else
            control my, note: degrees_seq(7, :"Cs#{octave-1}")[0]
          end

          rate = 1.0
          kick_start = 0.0
          control bit_fx, bits: 8
          control my, detune: 0.0

          swishing_saw degrees_seq(77777777777777777777, :"Cs#{octave-1}"), lpf_fx, beat
        end
      end
    end
    z+=1
  end
end

live_loop :pulse do |p_idx|
  x = nil
  with_fx :level, amp: 0.0 do
    sync :start
    with_fx :reverb, room: 100, mix: 0.9, dry: 0.1 do |reverb_fx|
      with_fx :slicer, phase: beat*2 do |s_fx|
        with_synth :growl  do
          x = play degree(1, :Cs4,:major), attack: 2, release: beat*32, amp: 0.25
        end
        (32/8).times{
          sleep beat*2
          control reverb_fx, room: (ring 0.1, 1.0)[p_idx], mix: ring(0.4, 0.9)[p_idx]
          p_idx +=1
        }
        (32/8).times{
          control s_fx, phase: beat

          sleep beat
          #control x, note:  degree(1, :Cs4,:major)
          control reverb_fx, room: (ring 0.9, 1.0)[p_idx], mix: ring(0.1, 0.9)[p_idx]
          p_idx +=1
          control s_fx, phase: beat/2

          sleep beat
        }
        control s_fx, phase: beat
        (32/8).times{
          sleep beat*2
          control x, note:  degree(6, :Cs3,:major)
          control reverb_fx, room: (ring 0.9, 1.0)[p_idx], mix: ring(0.1, 0.9)[p_idx]
          p_idx +=1
        }
      end
      #sleep beat*32
    end
  end
end

live_loop :pulse2 do
  with_fx :level, amp: 0.0 do
    sync :deep_notes
    with_fx :reverb, room: 100, mix: 0.9, dry: 0.1 do
      with_synth :growl  do
        play degree(7, :Cs3,:major), attack: 0.1, release: (beat/2)*18, amp: 0.50
      end
    end
  end
end

live_loop :atmos do
  with_fx :level, amp: 0.0 do
    cue :atmosphere
    use_synth :dark_ambience
    sync :hit
    play degree(3, :Cs3, :major), attack: 4, release: beat*32, amp: 1.0
    sleep beat*32

    sync :hit
    play degree(1, :Cs3, :major), attack: 4, release: beat*32, amp: 0.8
    sleep beat*32

    sync :hit
    play degree(7, :Cs2, :major), attack: 4, release: beat*32, amp: 0.8
    sleep beat*32
  end
end

live_loop :hollowed do
with_fx :level, amp: 0.0 do 
  sync :start
  hollowed_synth degree(3, :Cs4, :major)
end
end

set_volume! 1.0
