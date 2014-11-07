["support", "soprano", "samples"].each{|f| require "/Users/josephwilk/Workspace/repl-electric/sonic-pi/lib/#{f}"}
gravity_s = "/Users/josephwilk/Dropbox/repl-electric/samples/stars_gravity.wav"
bar = 1.0/1.0
live :timer do
  cue :circle
  sleep bar
  sleep bar
end
live :drummer do |n|
  use_synth :beep
  use_synth_defaults attack: 0.01, release: 0.01, amp: 0.7
  with_fx :lpf, cutoff: 100 do
    with_fx :reverb do
      sync :circle
      sample :drum_bass_soft, amp: 0.2, rate: 1.0 - (n%2==0 ? 0: 0.01)
      case (n%16)+1
      when 16
        play degree(1, :A3, :major), amp: 0.5
        sleep bar/8
        play degree(1, :A3, :major), amp: 0.6
        sleep (bar/8)*3
        sample :drum_bass_soft
        play degree(3, :A4, :major)
        sleep bar/4.0
        play degree(1, :A4, :major)
        sleep bar/4.0
        sleep bar/4.0
        play degree(4, :A4, :major)
        sleep bar/4.0
        sample :drum_bass_soft
        play degree(4, :A4, :major)
        sample :drum_tom_hi_soft
        sleep bar/2.0
        sample :drum_tom_lo_soft
      when 1..8
        play_pattern_timed [degree(1, :A4, :major), degree(1, :A4, :major),
        degree(1, :A4, :major), degree(1, :A4, :major)],
          [bar/4.0, bar/4.0, bar/4.0]
        sleep bar/4.0
        sleep bar
      when 8..16
        play_pattern_timed [degree(1, :A4, :major), degree(1, :A4, :major),
        degree(1, :A4, :major), degree(1, :A4, :major)],
          [bar/4.0, bar/4.0, bar/4.0]
        sleep bar/4.0
        sleep bar
end end end end
live :highlights do |n|
  use_synth :fm
  vol = 0.4
  if n%16 == 0
    2.times do
      sync :circle
      with_fx :reverb, room: 0.9 do
        play degree(1, :A2, :major), attack: bar, release: bar*2, amp: vol, decay: bar*2
      end
      sleep bar/2
      sleep bar/2

      sync :circle
      with_fx :reverb, room: 0.9 do
        play degree(4, :A2, :major), attack: bar, release: bar*2, amp: vol, decay: bar*2
      end
      sleep bar/2
      sleep bar/2
    end
  else
    sync :circle
    play degree(1, :A2, :major), attack: bar, release: bar*1, amp: vol
    sleep (bar)
    sync :circle
    play degree(4, :A2, :major), attack: bar, release: bar*1, amp: vol
    sleep bar
  end
end
live :higher do |n|
  vol = 0.9
  sync :high
  use_synth :beep
  play degree(6, :A3, :major), release: bar*2, attack: bar*2, amp: vol
end
live :higher2 do |n|
  vol = 0.2
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
  vol = 0.4
  sync :other_high

  use_synth :beep
  play degree(5, :A3, :major), release: bar*2, attack: bar*2, amp: vol
end
live :otherhigher2 do |n|
  vol = 0.1
  use_synth :tb303
  with_fx :reverb do
    sync :other_high
    if n%2 == 0
      play degree(5, :A3, :major), release: 0.3, attack: 0.01, amp: vol
      sleep bar*1
      play degree(3, :A3, :major), release: 0.2, attack: 0.01, amp: vol

      sleep bar*1
      with_fx :reverb, room: 0.9 do
        play degree(5, :A3, :major), release: bar*2, attack: 0.01, decay: bar/8, amp: vol
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
  drums = true
  use_synth_defaults amp: 0.4, release: bar/2.0
  play degree(1, :A3, :major)
  sleep bar/2.0
  play degree(3, :A3, :major)
  sleep bar/2.0
  case (n%32)
  when 3,7,  11,15,  27,31
    sample :drum_cymbal_closed, rate: 0.99, amp: 0.09, start: 0.1 if drums
    play degree(1, :A3, :major)
    sleep bar/2.0
    play degree(4, :A3, :major)
    sleep bar/4.0
    sample :drum_tom_lo_soft
    play degree(4, :A3, :major)
    sleep bar/4.0
  when 6, 30
    sample :drum_cymbal_closed, rate: 0.98, start: 0.05, amp: 0.1 if drums
    play degree(4, :E3, :major), attack: 0.03, amp: 0.5, release: bar/4
    sleep (bar/4.0)
    play degree(4, :E3, :major), attack: 0.03, release: bar/4
    sleep (bar/4.0)

    sample :drum_snare_soft, rate: 0.5, amp: 0.05, pan: (n%2 == 0 ? -0.25 : 0.25) if drums

    if n%32 == 6
      play degree(4, :A3, :major)
      sleep bar/4.0
      play degree(4, :A3, :major)
      sleep bar/4.0
    end
  else
    sample :drum_cymbal_closed, rate: 0.98, start: 0.15, amp: 0.1 if drums
    play degree(1, :A3, :major)
    sleep (bar/2.0)

    sample :drum_snare_soft, rate: 0.5, amp: 0.05, pan: (n%2 == 0 ? -0.25 : 0.25) if drums

    if n%32 == 12
      play degree(4, :A3, :major)
      sleep bar/4.0
      play degree(4, :A3, :major)
      sleep bar/4.0
    else
      play degree(4, :A3, :major)
      sleep bar/4.0
      play degree(4, :A3, :major)
      sleep bar/4.0
    end
    cue :high
  end
end
define :endbeep do |n|
  drums = true
  with_fx :reverb do
    sample :guit_harmonics if (dice(n%7) <= 3 ? (n%8 >= 6) : (n%8 <= 1))
  end
  vol = 0.4
  use_synth_defaults amp: 0.4
  play degree(1, :A3, :major)
  sleep bar/2.0
  play degree(3, :A3, :major)
  sleep bar/2.0
  case n%8
  when 3, 7
    sample :drum_cymbal_closed, rate: 1.99, amp: 0.1, start: 0.1 if drums
    play degree(1, :A3, :major)
    sleep bar/4.0
    sample(:drum_tom_hi_soft)  if drums
    play degree(5, :A3, :major), amp: vol+(n%8 == 7 ? 0.01: 0.0)
    sleep bar/4.0
    play degree(5, :A3, :major), amp: vol+(n%8 == 7 ? 0.02: 0.0)
    sleep bar/4.0
    sample :drum_tom_hi_soft  if drums
    sample :drum_cymbal_open, rate: 0.80, amp: 0.05, start: 0.1  if drums
    sample :elec_ping, amp: (n%8 == 3 ? 0.3 : 1.0)  if drums
    play degree(5, :A3, :major), amp: (n%8 == 7 ? 1.0 : 0.95), release: bar*2, decay: bar/2.0
    sleep bar/4.0

    sample(:drum_tom_hi_soft) if (n == 7 || n == 4) && drums
  else
    sample :drum_cymbal_closed, rate: 1.0, start: rrand(0.05,0.1), amp: 0.1 if drums
    play_pattern_timed([degree(1, :A3, :major),
                        degree(5, :A3, :major)], [bar/2.0,bar/2.0] )
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
        endbeep(n)
      end
    end
  end
end

live :low_undertones do |n|
  use_synth :tri
  #  use_synth_defaults
  sync :circle
  if n % 8 == 7
    #    play degree([3].choose, :A2, :major), attack: bar/2, release: bar, decay: bar, amp: 0.4
  else
    #   play degree([1].choose, :A2, :major), attack: bar/2, release: bar, decay: bar, amp: 0.4
  end
  sleep bar*4
  #  cue :high
end

#begone :beeping
#begone :words
begone :otherhigher2
begone :otherhigher
begone :higher2
begone :higher
#begone :highlights
#begone :drummer
#begone :low_undertones2
begone :low_undertones
set_volume! 1.0
#fadeout()
