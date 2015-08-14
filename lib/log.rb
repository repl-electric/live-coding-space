def note_inspect(n,ns="")
  n = [n] unless n.respond_to?(:map)
  if n
    "#{ns}[#{(n||[]).map{|n| n ? note_info(n).midi_string : "_"}}]"
  else
    "#{ns}[ _ ]"
  end
end