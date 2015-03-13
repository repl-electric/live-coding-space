beat = 1/2.0
shaker_s = "/Users/josephwilk/Dropbox/repl-electric/samples/pi/250531__oceanictrancer__shaker-hi-hat.wav"
clap_s = "/Users/josephwilk/Dropbox/repl-electric/samples/Analog\ Snares\ \&\ Claps/13\ \ EMT140\ \(3\).wav"
high_hat_s = "/Users/josephwilk/Workspace/music/samples/LOOPMASTERS\ EXCITE_PACK2014/ESSENTIAL_EDM_2/EDM2_SOUNDS_AND_FX/EDM2_Kit_1_HiHat_1.wav"
high_hat2_s = "/Users/josephwilk/Workspace/music/samples/LOOPMASTERS\ EXCITE_PACK2014/ESSENTIAL_EDM_2/EDM2_SOUNDS_AND_FX/EDM2_Kit_1_HiHat_2.wav"
#snare2_s = "/Users/josephwilk/Workspace/music/samples/LOOPMASTERS\ EXCITE_PACK2014/ESSENTIAL_EDM_2/EDM2_SOUNDS_AND_FX/EDM2_Kit_1_Clap_\&_Snare_2.wav"
snare2_s = :drum_snare_soft
voice_s = "/Users/josephwilk/Workspace/music/samples/soprano/Samples/Sustains/Ah p/vor_sopr_sustain_ah_p_01.wav"

live_loop :clapper do
  with_fx :level, amp: 0.0 do
    32.times{sync :hit}
    sample clap_s, start: 0.2, amp: 0.25
    sync :hit
    sample clap_s, start: 0.1, amp: 0.3
    sync :hit
    sample clap_s, start: 0.09, amp: 0.4
    sync :hit
    sample clap_s, amp: 0.4, rate: -1.0
  end
end

live_loop :voices do
  with_fx :level, amp: 0.0 do
    sync :atmosphere
    with_fx(:reverb, room: 1.0, damp: 1){with_fx(:reverb, room: 1.0, damp: 1){with_fx(:reverb, room: 1.0, damp: 1){with_fx(:reverb, room: 1.0, damp: 1){with_fx(:reverb, room: 1.0, damp: 1){
    sample voice_s, attack: 1.0, amp: 0.5}}}}}
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

r=0
r2 = 0
live_loop :ride do
  sync :half_beat
  sample (ring high_hat_s, high_hat_s,high_hat_s, high_hat2_s)[r2], amp: 0.3, start: 0.01
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

live_loop :heart do
  sync :hit
  sample :elec_hollow_kick, start: 0.1
end

n=0
live_loop :drums do
  cue :hit
  #sample clap_s, rate: 0.1, amp: 0.25
  with_fx(:lpf, cutoff: 40){
  sample :drum_heavy_kick, amp: 2, rate: 1.0} #0.7}
  sleep beat

  with_fx :level, amp: 1.0 do
    case n%6
    when 0
      with_fx(:slicer, phase: 1.0){with_fx(:echo, phase: beat/4, decay: 0.09){with_fx(:bitcrusher, bits: 6){
      sample snare2_s, amp: 1.2}}}
    when 3
      with_fx(:bitcrusher, bits: 8){
      sample snare2_s, amp: 1.2, start: 0.15}
    when 5
      with_fx(:bitcrusher, bits: 7){
      sample snare2_s, amp: 1.3, start: 0.15}
    else
      sample snare2_s, start: 0.20, amp: 1.1, rate: 1.0
    end
  end
  sleep beat
  n+=1
end

def degree_seq(pattern, root, scale)
  pattern.to_s.split.map(&:to_i)
end

z=0
live_loop :synth do
  # sync :beat
  use_synth :dsaw
  use_synth_defaults detune: 0.1, amp: 0.25, attack: 0.001, release: 0.25, note_slide: 1.0
  with_fx :lpf, cutoff: 70 do
    sync :hit
    my = play degrees_seq(222222222222222, :Cs4), release: beat/2*16*3, attack: 1
    control my, note: degrees_seq(2, :Cs4)[0]

    with_fx :pitch_shift, pitch_dis: 0.001, time_dis: 0.01 do
      play_pattern_timed degrees_seq(222222222222222222, :Cs4),
        [beat/2, beat/2, beat/2, beat/2, beat/2, beat/2]
      sync :hit
      control my, note: degrees_seq(1, :Cs4)[0]

      play_pattern_timed degrees_seq(1111111111111111111, :Cs4),
        [beat/2, beat/2, beat/2, beat/2, beat/2, beat/2]
      sync :hit

      if(dice(6) >= 5)
        control my, note: degrees_seq(7, :Cs4)[0]
      else
        control my, note: degrees_seq(7, :Cs3)[0]
      end

      play_pattern_timed degrees_seq(77777777777777777777, :Cs3),
        [beat/2, beat/2, beat/2, beat/2, beat/2, beat/2]

      #  play_pattern_timed chord_seq(21141111, :A1),
      ##                     [beat/4, beat/2, beat/4, beat/4,
      #                      beat/4, beat/2, beat/2, beat/4]
    end
  end
  z+=1
end

live_loop :pulse do
  sync :start
  with_fx :reverb, room: 100, mix: 0.9, dry: 0.1 do
    with_synth :growl  do
      play degree(1, :Cs4,:major), attack: 2, release: beat*32, amp: 0.25
    end
  end
  sleep beat*32
end

live_loop :atmos do
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
