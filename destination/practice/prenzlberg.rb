["support", "soprano", "samples"].each{|f| require "/Users/josephwilk/Workspace/repl-electric/sonic-pi/lib/#{f}"}

bar = 1.0/2.0
clap_s = csample("183102__dwsd__clp-bodacious.wav")

live(:words) do |n|
  sync :circleofeight
  if n % 16 == 0
    with_fx :rlpf, cutoff: 50 do
      sample Sop.yehp[1], amp: 8
      #sample Sop.yehp[1], release: bar*8, amp: 4
    end
  end
  sleep bar*4
end

live(:drums) do
  with_fx :lpf, cutoff: 65 do
    15.times do |n|
      cue :circleofeight
      sample :drum_bass_soft
      sleep bar/2.0
      if (n%4 == 0)
        sample clap_s
      end
      if n == 7
        sample clap_s
        sleep bar/4
        sample clap_s
        sleep bar/4
      else
        sleep bar/2
      end

    end
    sample :drum_bass_soft
    sleep bar/2
    sample :drum_bass_soft
    sample :drum_cymbal_pedal
    sleep bar/2
  end
end

live :synths do |n|
  use_synth :beep
  with_fx :slicer, phase: bar do
    if n % 16 != 15
      play :D3
      sleep bar
    else
      with_fx :echo, phase: bar*4  do
        play :D4
      end
      sleep bar/2.0
      play :D3
      sleep bar/2.0
    end
  end
end

live :synths2 do |n|
  vol = 1.0
  use_synth :fm
#  use_synth_defaults attack: 0.4, res: 0.08, attack: 0.8, release: 0.5, cutoff: 50, amp: 1.2
  with_fx :slicer, phase: bar do
    use_synth :fm
    if n % 16 != 15
      sleep bar
    else
      if n % 32 == 15
        with_fx :echo, phase: bar do
          play :D3, amp: vol
        end
        sleep bar/2.0
        sleep bar/2.0
        play :D2, amp: vol
      elsif n % 32 == 31
        sleep bar/2.0
        play :D3, amp: vol
        sleep bar/2.0
        play :D3, amp: vol
      else
        sleep bar/2.0
        sleep bar/2.0
      end
    end
  end
end

live :sins do |n|
  sync :circleofeight
  #  sync :highlight
  with_fx :rlpf, cutoff: 90 do
    with_fx :reverb do
      use_synth :beep
      play :D4, release: bar*8, attack: 0.25, decay: bar, amp: 0.5
      sleep bar*8
      play :C4, release: bar*8, attack: 0.25, decay: bar, amp: 0.5
      sleep bar*8
      play :E4, release: bar*8, attack: 0.25, decay: bar, amp: 0.5
      sleep bar*8
      play :D3, release: bar*8, attack: 0.20, decay: bar*2, amp: 0.9
      sleep bar*8
    end
  end
end

live :sins2 do |n|
  sync :circleofeight
  with_fx :lpf, cutoff: 60 do
    use_synth :pretty_bell
    play :D4, amp: 0.5, attack: 0.2, release: bar*8, amp: 0.5, decay: bar
    sleep bar*8
    play :C4, amp: 0.5, attack: 0.2, release: bar*8, amp: 0.5, decay: bar
    sleep bar*8
  end
end

live :noise do |n|
  synth :circleofeight
  use_synth :pnoise
  with_fx :pan, pan: (Math.sin(n)) do
    with_fx :reverb do
      with_fx :lpf, cutoff: 30 do
        play :D6, release: bar*16, amp: 2.5
        sleep bar * 16
      end
    end
  end
end

live :highlight do |n|
  use_synth :zawa
  vol = 0.3

  with_fx :echo do
    sync :circleofeight
    with_fx :lpf, cutoff: 60 do
      play_chord chord(:D3, :major),  release: bar*8, amp: vol-0.1, decay: bar*2, phase: bar*2
      #play_chord chord(:D3, :major),   release: bar*8, amp: vol, decay: bar, phase: bar*2
      sleep bar*8

      play_chord chord(:D3, :sus4),   release: bar*8, amp: vol-0.1, decay: bar*2, phase: bar*2
      #play_chord chord(:D3, :sus4),    release: bar*8, amp: vol, decay: bar*2, phase: bar*2
      sleep bar*8

      play_chord chord(:D3, :major),   release: bar*4, amp: vol-0.1, decay: bar*2, phase: bar*2
      #play_chord chord(:D3, :"7sus4"), release: bar*4, amp: vol+0.1, decay: bar*2, phase: bar*2
      sleep bar*4

      play_chord chord(:D3, :major),   release: bar*4, amp: vol, decay: bar*2, phase: bar*2
      sleep bar*4

      play_chord chord(:D3, :sus4),    release: bar*4, amp: vol, decay: bar*2, phase: bar*2
      sleep bar*4

      with_fx :reverb do
        play_chord chord(:D3, :major),   release: bar*4, amp: 0.5, decay: bar*4, phase: bar*2
        sleep bar*4
      end
    end
  end
end

#begone :drums
#begone :sins
#begone :sins2
begone :noise
#begone :synths
#begone :synths2
#begone :highlight
#begone :words
