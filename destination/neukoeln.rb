["support", "soprano", "samples"].each{|f| require "/Users/josephwilk/Workspace/repl-electric/sonic-pi/lib/#{f}"}

gravity_s = "/Users/josephwilk/Dropbox/repl-electric/samples/stars_gravity.wav"

bar = 1.0/1.0
live :timer do
  cue :circle
  sleep bar
  sleep bar
end

live :end_of_bar do |n|
  use_synth :beep
  use_synth_defaults attack: 0.01, release: 0.01
  sync   :start
  play degree(1, :A2, :major)
  sleep bar/2.0
  with_fx :lpf, cutoff: 80 do sample :drum_bass_soft end

  play degree(3, :A2, :major)
  sleep bar/4.0
  play degree(1, :A2, :major)
  sleep bar/4.0

  sleep bar/4.0
  play degree(4, :A2, :major)
  sleep bar/4.0
  with_fx :lpf, cutoff: 90 do sample :drum_bass_soft end

  play degree(4, :A2, :major)
  with_fx :lpf, cutoff: 90 do sample :drum_tom_lo_soft end
  sleep bar/2.0
  with_fx :reverb do with_fx :lpf, cutoff: 90 do sample :drum_tom_hi_soft end end
end

live :drummer do |n|
  use_synth :beep
  use_synth_defaults attack: 0.01, release: 0.01
  with_fx :lpf, cutoff: 80 do
    with_fx :reverb do
      sync :circle
      puts n
      case (n%16)+1
      when 1
        sample :drum_bass_soft
        play degree(1, :A3, :major)
        sleep (bar/2.0)
        play degree(1, :A3, :major)
        sleep bar/2.0
        play degree(1, :A3, :major)
        sleep bar/2.0
        play degree(1, :A3, :major)
        sleep bar/2.0
      when 8
        sample :drum_bass_soft
        play degree(1, :A3, :major)
        sleep bar/2.0
        play degree(1, :A3, :major)
        sleep bar/2.0
        play degree(1, :A3, :major)
        sleep bar/2.0
        play degree(1, :A3, :major)
        sleep bar/2.0
      when 4, 12
        with_fx :lpf, cutoff: 80 do sample :drum_bass_soft, rate: 1.0 + 0.1*n%2 end
        play degree(1, :A4, :major)
        sleep bar/2.0
        play degree(1, :A4, :major)
        sleep bar/2.0
        play degree(1, :A4, :major)- n%2
        sleep bar
      else
        with_fx :lpf, cutoff: 80 do sample :drum_bass_soft, rate: 1.0 + 0.1*n%2 end
        play degree(1, :A4, :major)
        sleep bar
        play degree(1, :A4, :major)
        sleep bar
      end
    end
  end
end

live :highlights do |n|
  use_synth :fm
  vol = 0.6
  sync :circle
  play degree(1, :A2, :major), attack: bar, release: bar*1, amp: vol
  sleep bar*1
  sync :circle
  play degree(4, :A2, :major), attack: bar, release: bar*1, amp: vol
  sleep bar*1
end

live :higher do |n|
  vol = 0.6
  sync :high
  use_synth :beep
  play degree(6, :A3, :major), release: bar*2, attack: bar*2, amp: vol

  with_fx :lpf, cutoff: 70 do
    with_fx :echo, phase: bar do
      with_fx :reverb do
        use_synth :zawa
        play_chord chord(:A5, :major), release: bar*2, attack: bar, decay: bar, amp: 0.3,  cutoff: 50, res_slide: 0.2
      end
    end
  end
end

live :higher2 do |n|
  vol = 0.5
  use_synth :tb303
  #use_synth :beep
  with_fx :reverb do
    sync :high
    if n%2 == 0
      play degree(5, :A4, :major), release: 0.3, attack: 0.01, amp: vol
      sleep bar*1
      play degree(3, :A4, :major), release: 0.2, attack: 0.01, amp: vol

      sleep bar*1
      with_fx :reverb do
        play degree(3, :A4, :major), release: bar*2, attack: 0.01, decay: bar/4, amp: vol
        sleep bar/2
        play degree(6, :A4, :major), release: 0.15, attack: 0.01, amp: vol
        sleep bar/2
        play degree(6, :A4, :major), release: 0.1, attack: 0.01, amp: vol
        sleep bar
      end
    end
  end
end

live :otherhigher do |n|
  sync :other_high

  use_synth :beep
  play degree(5, :A3, :major), release: bar*2, attack: bar*2
end

live :otherhigher2 do |n|
  vol = 0.6
  use_synth :tb303
  with_fx :reverb do
    sync :other_high
    if n%2 == 0
      play degree(5, :A3, :major), release: 0.3, attack: 0.01, amp: vol
      sleep bar*1
      #with_fx :reverb do
      play degree(3, :A3, :major), release: 0.2, attack: 0.01, amp: vol

      sleep bar*1
      with_fx :reverb, room: 0.9 do
        play degree(5, :A3, :major), release: bar*2, attack: 0.01, decay: bar/8
        sleep bar/2
        play degree(3, :A3, :major), release: 0.15, attack: 0.01, amp: vol
        sleep bar/2
        play degree(3, :A3, :major), release: 0.1, attack: 0.01, amp: vol
        sleep bar
      end
    end
  end
end

live :words do
  sync :circle
  with_fx :ixi_techno, phase: bar*4 do
    sample gravity_s, amp: 1
    sleep 8*sample_duration(gravity_s)
  end
end

define :startbeep do |n|
  use_synth_defaults amp: 0.5
  play degree(1, :A3, :major)
  sleep bar/2.0
  play degree(3, :A3, :major)
  sleep bar/2.0

  if n == 3 || n == 7
    play degree(1, :A3, :major)
    sleep bar/2.0
    play degree(4, :A3, :major)
    sleep bar/4.0
    with_fx :lpf, cutoff: 70 do sample :drum_tom_lo_soft end
    play degree(4, :A3, :major)
    sleep bar/4.0
  else
    with_fx :lpf, cutoff: 80 do sample :drum_snare_soft end
    play degree(1, :A3, :major)
    sleep bar/2.0
    with_fx :lpf, cutoff: 80 do sample :drum_snare_soft end
    play degree(4, :A3, :major)
    sleep bar/2.0
    cue :high
  end
end

define :endbeep do |n|
  use_synth_defaults amp: 1
  play degree(1, :A3, :major)
  sleep bar/2.0
  play degree(3, :A3, :major)
  sleep bar/2.0

  if n == 3 || n == 7
    play degree(1, :A3, :major)
    sleep bar/4.0
    with_fx :lpf, cutoff: 70 do sample(:drum_tom_hi_soft); end
    play degree(5, :A3, :major)
    sleep bar/4.0
    play degree(5, :A3, :major)
    sleep bar/4.0
    with_fx :lpf, cutoff: 70 do sample(:drum_tom_hi_soft); end
    play degree(5, :A3, :major)

    sleep bar/4.0
    if n == 7 || n == 4
      with_fx :lpf, cutoff: 90 do sample(:drum_tom_hi_soft); end
    end
  else
    play degree(1, :A3, :major)
    sleep bar/2.0
    play degree(5, :A3, :major)
    sleep bar/2.0
    cue :other_high
  end
end

live :beeping do
  use_synth :beep
  with_fx :echo, phase: bar/4.0 do
    with_fx :reverb do
      8.times do |n|
        sync :circle
        startbeep(n)
      end

      8.times do |n|
        sync :circle
        cue :start if n == 7
        endbeep(n)
      end
    end
  end
end

begone :beeping
begone :words
begone :otherhigher2
begone :otherhigher
begone :higher2
begone :higher
begone :highlights
begone :drummer

set_volume! 1
#fadeout()
