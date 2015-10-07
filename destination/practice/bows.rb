["instruments","shaderview","experiments", "log"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}
_=nil
load_snippets("~/.sonic-pi/snippets/")

# d[-_-]b
#   /█\
#  .Π.

#Fin, thanks.

with_fx(:reverb, room: 1.0, mix: 1.0) do
  live_loop :sop do
    with_fx(:slicer, phase: 0.25) do
      # sample Sop[/F#/,0], cutoff: 55
    end
    sleep 4
    #    sample Sop[/A#/,2], cutoff: 55
    #    sleep 4
  end
end

live_loop :dark do
  with_fx :reverb do
    with_fx(:pitch_shift, window_size: 0.1, pitch_dis: 0.01,
    mix: 0.1) do
      with_synth :dark_sea_horn do
        #lets see what it sound like if we go higher...
        play (ring :fs4, :as3, :ds3, :Fs3, :As3, :Cs3),
          cutoff: 20,
          decay: 8.1, amp: 0.7
      end
      sleep 8
    end
  end
end

live_loop :bows do
  with_fx((knit :reverb,3, :echo,0).tick(:maybe?), room: 0.0, mix: 1.0) do |fx|
    synth :dark_ambience,
      note: (ring :Fs3, :Fs3, :Fs3, :Gs3).tick(:dark), decay: 8.1, attack: 1.0, detune1: 24, detune2: 12

    #    with_fx(:distortion, mix: (ring 0.0, 0.0, 0.1, 0.15).tick) do
    #    sample Mountain[/bow/, knit(/G#/,3).tick(:bows),0], amp: 0.2
    #    end
    8.times{control fx, damp: rrand(0,1); sleep 1}
  end
end

live_loop :har do
  #  i_hollow((ring :fs2, :as2, :es2, :gs2).tick, amp: 0.5)
  sleep 1.0
end

live_loop :corruption do
  with_fx(:echo, phase: 0.5, decay: 0.8, mix: (knit 0.5,1,0.0,3).tick(:mix)) do
    #    with_fx(:slicer, phase: 0.25, smooth: 0.03) do
    #sample Dust[/kick/,10], cutoff: 60
    #    end
  end
  sleep 1
  with_fx(:bitcrusher, bits: (ring 10, 16).tick(:bits), sample_rate: 10000) do
    with_fx((ring :reverb, :reverb, :reverb, :echo).tick(:Fx), decay: 2.0) do
      #sample Frag[/F#/,[0,1]].tick(:s), cutoff: 40, amp: 0.6, start: 0.98
    end
  end
  sleep 1
end
