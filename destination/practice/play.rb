bar = 1.0/2.0

clap_s = csample("183102__dwsd__clp-bodacious.wav")
oboe_s = {}

oboe_s[:A3] = "/Users/josephwilk/.overtone/orchestra/cello/cello_A3_1_forte_arco-normal.wav"
oboe_s[:A2] = "/Users/josephwilk/.overtone/orchestra/cello/cello_A2_1_forte_arco-normal.wav"
oboe_s[:A4] = "/Users/josephwilk/.overtone/orchestra/cello/cello_A4_1_forte_arco-normal.wav"

oboe_s[:C2] = "/Users/josephwilk/.overtone/orchestra/cello/cello_C2_15_forte_arco-normal.wav"
oboe_s[:C3] = "/Users/josephwilk/.overtone/orchestra/cello/cello_C3_025_forte_arco-normal.wav"
oboe_s[:C4] = "/Users/josephwilk/.overtone/orchestra/cello/cello_C4_025_forte_arco-normal.wav"

oboe_s[:D2] = "/Users/josephwilk/.overtone/orchestra/cello/cello_D2_1_fortissimo_arco-normal.wav"
oboe_s[:D3] = "/Users/josephwilk/.overtone/orchestra/cello/cello_D3_1_fortissimo_arco-normal.wav"
oboe_s[:D4] = "/Users/josephwilk/.overtone/orchestra/cello/cello_D4_1_fortissimo_arco-normal.wav"

oboe_s[:E4] = "/Users/josephwilk/.overtone/orchestra/cello/cello_E4_1_fortissimo_arco-normal.wav"
oboe_s[:E3] = "/Users/josephwilk/.overtone/orchestra/cello/cello_E3_1_fortissimo_arco-normal.wav"
oboe_s[:E2] = "/Users/josephwilk/.overtone/orchestra/cello/cello_E2_1_fortissimo_arco-normal.wav"

oboe_s[:F4] = "/Users/josephwilk/.overtone/orchestra/cello/cello_F4_1_forte_arco-normal.wav"
oboe_s[:F3] = "/Users/josephwilk/.overtone/orchestra/cello/cello_F3_1_forte_arco-normal.wav"
oboe_s[:F2] = "/Users/josephwilk/.overtone/orchestra/cello/cello_F2_1_forte_arco-normal.wav"

live(:timer) do |n|
  cue :circleofeight
  sleep bar
end

live :sins do |n|
  #  sync :highlight
  with_fx :rlpf, cutoff: 90 do
    octave = 4
    with_fx :slicer, phase: 0.0029 do
    with_fx :reverb, mix: 1.0, room: 1 do
      use_synth :beep
      sync :circleofeight
      play :"D#{octave}", release: bar*8, attack: 0.25*2, decay: bar*2, amp: 0.5
      sleep bar*8
      play :"C#{octave}", release: bar*8, attack: 0.25*2, decay: bar*2, amp: 0.5
      sleep bar*8
      play :"E#{octave}", release: bar*8, attack: 0.25*2, decay: bar*2, amp: 0.5
      sleep bar*8
      play :"D#{octave-1}", release: bar*8, attack: 0.20*2, decay: bar*4, amp: 0.9
      sleep bar*8
      end
    end
  end
end

live :sins2 do |n|
  sync :circleofeight
  octave = 4
  with_fx :lpf, cutoff: 60 do
    use_synth :pretty_bell
    play :"D#{octave}", amp: 0.5, attack: 0.2, release: bar*16, amp: 0.5, decay: bar
    sleep bar*8
    play :"C#{octave}", amp: 0.5, attack: 0.2, release: bar*16, amp: 0.5, decay: bar
    sleep bar*8
  end
end

live(:drums) do
  with_fx :lpf, cutoff: 80 do
    15.times do |n|
      sync :circleofeight
      sample :drum_bass_soft
      sleep bar
      if (n%4 == 0)
          sample :drum_bass_soft
      end
      if n == 7
        sample :drum_bass_soft
        sleep bar/2
          sample :drum_bass_soft
        sleep bar/2
      else
        sleep bar
      end
    end
    sync :circleofeight
    sample :drum_bass_soft, rate: -1
    sleep bar
    sample :drum_bass_soft
    sleep bar
  end
end

live :ints do |n|
  with_fx :reverb do
  sync :circleofeight
  s = oboe_s.to_a.sample(1)[-1][-1]
  case n%32
  when 7,15,31 
    s = oboe_s[:C4]
  when 8,16,1
    s = oboe_s[[:E4, :D4, :C4].choose]
  else
    s = oboe_s[:C2]
  end
  sample s , amp: rrand(0.8,1.0) if s
  sleep  bar/2
end
end

live :beep do |n|
  use_synth :beep
  use_synth_defaults attack: 0.1, release: bar/4
  sync :circleofeight
  sleep bar/2
  case n%32
  when 8
    play degree(2, :C2, :major)
    sleep bar/2
  when 16
    play degree(4, :C2, :major), attack: 0.05, amp: 0.8
    sleep bar/4
    play degree(4, :C2, :major), attack: 0.05, amp: 0.9
    sleep bar/4
    play degree(4, :C2, :major), attack: 0.04, amp: 1.0
  when 31
    play degree(5, :C2, :major), attack: 0.08, amp: 0.8
    sleep bar/2
    play degree(5, :C2, :major), attack: 0.08, amp: 0.9
    sleep bar/2
  else
    play degree(1, :C2, :major)
    sleep bar/2
  end
end

live :darkness do |n|
  use_synth :fm
  sync :circleofeight
  with_fx :pan, pan: dice(6) > 3 ? 0.25 : -0.25 do
  case n%32
  when 30,31
  else
    with_fx :lpf, cutoff: 120 do
      play degree(1, :C3, :major), attack: bar, release: bar*4, decay: bar*4, amp: 1.0
    end
  end
  end
  4.times {|_| sync :circleofeight}
end

begone(:darkness)
#begone(:beep)
#begone(:ints)
#begone(:drums)
#begone(:sins)
#begone(:sins2)
fadeout()