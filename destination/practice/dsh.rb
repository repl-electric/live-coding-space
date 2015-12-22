set_volume! 1.3
_=nil
live_loop :go do
  cs = ring(
    [:Fs3, :A3,  :Cs3, _],        #5 in
    [:Fs3, :A3,  :Cs4, _],        #1

    [:A3,  :Cs4, :E4, _],         #3
    [:Cs3, :E3,  :Gs3, :B3],      #5
    [:Cs3, :E4,  :Gs4, :B4],
    [:D3, :Fs3,  :A3, _],         #6th
    [:E3, :Gs3,  :B3,  :D3] ,      #7th


    [:Fs3, :A3,  :Cs3, _],        #     5 in
    [:Fs3, :B3,  :Cs4, _],        #sus4 1

    [:A3,  :Cs4, :E4, _],         #3
    [:Cs3, :E3,  :Gs3, :B3],      #5
    #    [:Cs3, :E4,  :Gs4, :B4],
    [:D3, :Fs3,  :A3, _],         #6th
    [:E3, :Gs3,  :B3,  :E2]       #7th
  )
  c = cs.tick(:main)

  # synth :hollow, note: ring(c[0]-5, c[0], c[0]).tick(:cut), release: 4.0, decay: 10.0, amp: 0.2, attack: 4.0, cutoff: 80

  with_transpose -12*2 do
    #s1 = synth :gpa, note: ring(  c[0]).tick(:bassvoice), decay: 4.0, cutoff: 70, amp: 2.0, wave: 6
  end
  #synth :leadsaw, note: :Gs4,  amp: 0.8, decay: 16.0, amp: 0.4
  #synth :dsaw,  note: :Gs4, cutoff: 60, amp: 0.4, decay: 16.0, detune: 12, attack: 0.1

  with_transpose -12 do
    with_fx(:reverb, room: 0.9, mix: 0.4, damp: 0.5) do |r_fx|
      #   synth :dsaw,  note: c[0]+0, cutoff: 60, amp: 0.5, decay: 8.0, detune: 12, attack: 0.1
      #   synth :prophet, note: c[0]+0, cutoff: 60, amp: 0.5, decay: 8.0,attack: 0.1
    end
  end

  _=nil
  s1,s2,s3=nil


  with_fx :pitch_shift, time_dis: 0.05 do

    with_transpose -12*3 do
      s3 = synth :dark_sea_horn, note: c[0], decay: 8.0, cutoff: 130, amp: 0.6, attack: 0.0, noise1: 3.0, noise2: 3.0
    end

    with_transpose 12 do
      # synth :leadsaw, note: c[0..2], attack: 0.0000001, cutoff: 75, amp: 1.3, release: 8.0, decay: 8.0, sustain: 8.0
    end
    #s = synth :dsaw,  note: c[0..2], cutoff: 60, sustain: 1.0, release: 1.0, decay: 4.0, amp: 0.2, detune: 12

    #s1 = synth :dark_sea_horn, note: c[0], decay: 16.1, cutoff: 60, amp: 0.2
    sleep 1
    #s2 = synth :dark_sea_horn, note: c[1], decay: 15.0, cutoff: 65, amp: 0.2
    sleep 1
    #    s3 = synth :dark_sea_horn, note: c[2], decay: 15.0, cutoff: 65, amp: 0.2

  end
  if c.length > 3
    #  s3 = synth :dark_sea_horn, note: c[-1], decay: 8.0, cutoff: 130, amp: 1.0,  noise1: 0.1, noise2: 3, attack: 4.0
  end


  with_fx(:reverb, room: 0.9, mix: 0.4, damp: 0.5) do |r_fx|
    #synth :hollow,        note: c[-1], amp: 1.5, release: knit( 8.0,3, 16,1).tick(:release), decay: 8.0, attack: 4.0, cutoff: 70
    #synth :dark_ambience, note: c[-1] + ring( 0).tick(:bass), amp: 0.2, release: knit( 8.0,3, 16,1).tick(:release)/2.0, decay: 8.0/2.0, attack: 4.0, cutoff: 70
  end

  sleep 0
  mess = [s1,s2,s3].reject{|x|x.nil?}.choose
  (16-2).times{ |n|
    #control mess, note: scale(:Fs3, :minor_pentatonic).shuffle.choose
    #control mess, note: :Fs3

    sleep 1

    if  n == 5
      #sample Organic[/kick/,[1,1]].tick(:sample), cutoff: 100, amp: 0.2
      with_transpose -12*2 do
        #   s1 = synth :gpa, note: ring(  c[0]).look(:bassvoice), decay: 4.0, cutoff: 60, amp: 2.0, wave: 6
      end
    end

  }
end

with_fx :pitch_shift, time_dis: 0.8,  pitch_dis: 0.8 do
  live_loop :end do
    sample_and_sleep Mountain[/cracklin/], rate: 0.9, amp: 0.3
  end
end

live_loop :hollow do
  sync :go
  #control mess, note: :Fs3 #scale(:Fs3, :minor_pentatonic).shuffle.choose#, noise1: 0.0
  8.times{
    # sample Organic[/perc/, 8], amp: range( 0.01, 0.0).tick(:amp)*0.08
    #i_hollow scale(:Fs4, :minor_pentatonic).shuffle.choose, amp: 8.0*3
    sleep 0.25
    #sample Organic[/perc/, 9], amp: 0.0
    sleep 0.25
  }
  8.times{
    #sample Organic[/perc/, 8], amp: 0.05
    sleep 0.25
    sleep 0.25
  }
end

live_loop :beat do
  #sync :go
  #sample Mountain[/subkick/,[0,0,0,0]].tick(:sample), cutoff: 80, amp: 0.2
  #  with_fx(:slicer, phase: ring( 2.0,2.0,1,1).tick(:ph), probability: 0) do

  with_fx(:pitch_shift, mix: 1.0, time_dis: 0.01) do
    with_fx :slicer, mix: 0.0 do
      #with_fx :bitcrusher, bits: 64*8, mix: 0.1 do
      #     sample Organic[/loop/, 11], amp: 0.3, beat_stretch: 16,      cutoff: 100
      #     sample Organic[/loop/, 11], amp: 0.1, beat_stretch: 16*2,    cutoff: 100
      #      sample Organic[/loop/, 11], amp: 0.1, beat_stretch: 16/2.0,  cutoff: 100

      with_fx(:slicer, phase: 0.25*2) do
        #      sample Organic[/loop/, 11], amp: 0.3, beat_stretch: 16, cutoff: 80, rate: -1
      end

      #end
    end
  end

  #  with_fx :hpf, cutoff: 100, mix: 0.0 do
  #   with_fx :bitcrusher, bits: 64*8, sample_rate: 80000, mix: rand do
  #sample CineAmbi[/kick/,0], cutoff: 130, amp: 0.1, beat_stretch: 16
  #  end
  # end
  sleep 1
  #sample Mountain[/subkick/,[0,0]].tick(:sample), cutoff: 80, amp: 4.5
  sleep 1
  #sample Mountain[/subkick/,[1,1]].tick(:sample), cutoff: 70, amp: 2.5

  sleep 16-2
end
