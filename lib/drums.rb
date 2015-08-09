def dpat(s, p, delta=0, *args)
 sync :drum_hit
 case p
   when  "x" #hit
    sleep(delta) if delta != 0
    sample *([s]+args)
   when  "r" #random
    sleep(delta) if delta != 0
    sample *([s]+args) if dice(6) > 3
  end
end

def drum_loop(name, state, sample, *args)
  state = expand_pattern(state)
  live_loop name, auto_cue: false do  
     dpat(sample.is_a?(SonicPi::Core::RingVector) ? sample.tick("#{name}_sample".to_sym) : sample, state.tick(name), 
         delta=(args[0][:delta] || 0),
         *[args[0].reduce({}){|a,(k,v)|
     v.is_a?(SonicPi::Core::RingVector) ? a[k]=v.tick("#{name}_#{k}".to_sym) : a[k]=v
     a}])
  end
end

def expand_pattern(pat)
  pat.to_a.map{|slice| 
  case slice
  when /^-\*(\d+)$/
    _, n = *slice.match(/^-\*(\d+)$/)
    ("-"*n.to_i).split("")
  else
    slice
  end
  }.flatten.ring
end
