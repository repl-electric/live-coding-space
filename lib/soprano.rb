module Sop
  ROOT =  "/Users/josephwilk/Workspace/music/samples/soprano/Samples"

  def self.yehp
    sop1 = "#{ROOT}/Sustains/Yeh p/vor_sopr_sustain_eh_p_01.wav"
    sop2 = "#{ROOT}/Sustains/Yeh p/vor_sopr_sustain_eh_p_02.wav"
    sop3 = "#{ROOT}/Sustains/Yeh p/vor_sopr_sustain_eh_p_03.wav"
    sop4 = "#{ROOT}/Sustains/Yeh p/vor_sopr_sustain_eh_p_04.wav"
    [sop1, sop2, sop3]
  end
  
  def self.ahp
    sop1 = "#{ROOT}/Sustains/Ah p/vor_sopr_sustain_ah_p_01.wav"
    sop2 = "#{ROOT}/Sustains/Ah p/vor_sopr_sustain_ah_p_02.wav"
    sop3 = "#{ROOT}/Sustains/Ah p/vor_sopr_sustain_ah_p_03.wav"
    sop4 = "#{ROOT}/Sustains/Ah p/vor_sopr_sustain_ah_p_04.wav"
    [sop1, sop2, sop3]
  end
  
end

def sop(note, short=0)
  n = case note.to_s.downcase.to_sym
  when :a3
    6
  when :c4
    7
  when :d3
    1
  when :e3
    3
  when :b3
    5
  end
  Sop[/vor_sopr_sustain_mm_p_0#{n}/, short]
end
