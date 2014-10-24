["support", "soprano", "samples"].each{|f| require "/Users/josephwilk/Workspace/repl-electric/sonic-pi/lib/#{f}"}

bar = 1/2.0
clap_s = csample("183102__dwsd__clp-bodacious.wav")

live(:words) do
  sync :drums
  with_fx :lpf, cutoff: 70 do
    sample Sop.yehp.choose, release: bar*16, amp: 2
  end
  sleep bar*8 
end

live(:drums) do
  with_fx :lpf, cutoff: 70 do
    15.times do |n|
      sample :drum_bass_soft
      sleep bar/2.0
      if (n%4 == 0)
        sample clap_s
      end
      if n == 7
        sample clap_s
        sleep bar/4.0
        sample clap_s
        sleep bar/4.0
      else
        sleep bar/2.0
      end
      #sample :drum_snare_soft if n % 2 == 0
    end
    sample :drum_bass_soft
    sleep bar/2
    sample :drum_bass_soft
    sleep bar/2
    #sample :drum_bass_soft
    
  end
end

live :synths do |n|
  use_synth :beep
  with_fx :slicer, phase: bar do
    if n % 16 != 15
      play :D3
      sleep bar
    else
      play :D4
      sleep bar/2.0
      play :D3
      sleep bar/2.0
    end
  end
end

live :sins do |n|
sync :highlight
  with_fx :reverb do
    use_synth :beep
    play :D4, release: bar*8, attack: 0.25, decay: bar*2, amp: 0.5
    sleep bar*8
    play :C4, release: bar*8, attack: 0.25, decay: bar*2, amp: 0.5
    sleep bar*8
    play :E4, release: bar*8, attack: 0.25, decay: bar*2, amp: 0.5
    sleep bar*8
    play :D3, release: bar*8, attack: 0.25, decay: bar*2, amp: 0.5
    sleep bar*8
  end
end

live :sins2 do |n|
  with_fx :lpf, cutoff: 60 do
    use_synth :pretty_bell
    play :D4, amp: 0.9, attack: 0.2, release: bar*8
    sleep bar*8
    play :C4, amp: 0.9, attack: 0.2, release: bar*8
    sleep bar*8
  end
end

live :noise do |n|
  use_synth :pnoise
  with_fx :pan, pan: (Math.sin(n)) do
    with_fx :reverb do
      with_fx :lpf, cutoff: 55 do
        play :D6, release: bar*16, amp: 0.5
        sleep bar * 16
      end
    end
  end
end

live :highlight do |n|
  use_synth :zawa
  with_fx :echo do
    with_fx :lpf, cutoff: 60 do
      play_chord chord(:D3, :major),   release: bar*8, amp: 0.5, decay: bar*8
      sleep bar*8

      play_chord chord(:D3, :sus4),    release: bar*8, amp: 0.6, decay: bar*8
      sleep bar*8

      play_chord chord(:D3, :"7sus4"), release: bar*4, amp: 0.6, decay: bar*4
      sleep bar*4

      play_chord chord(:D3, :major),   release: bar*4, amp: 0.6, decay: bar*4
      sleep bar*4

      play_chord chord(:D3, :sus4),    release: bar*4, amp: 0.6, decay: bar*4
      sleep bar*4

      play_chord chord(:D3, :major),   release: bar*4, amp: 0.6, decay: bar*4
      sleep bar*4
    end
  end
end

#begone :drums
#begone :sins
#begone :sins2
#begone :noise
#begone :synths
#begone :highlight