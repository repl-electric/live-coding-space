live_loop :do do
  sample Fraz[/kick/,[0,0]].tick(:sample2), cutoff: 100, amp: 1.5
  with_fx(:ixi_techno, phase: 8.0) do
    sample Frag[/interference/,/f#m/,[2,2]].tick(:sample), amp: 2.5, beat_stretch: 16
  end

  at do
    sleep 8
    if(dice(6) > 3)
      sample Frag[/interference/,/f#m/,[2,2]].tick(:sample), amp: 2.5, beat_stretch: 8, rate: 0.5
    end
  end
  sleep 4
end

live_loop :loop do

end
