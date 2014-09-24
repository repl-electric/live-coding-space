def csample(name)
  root = "/Users/josephwilk/Dropbox/repl-electric/samples/pi"
  "#{root}/#{name}"
end

def define_loop(name, &block)
  define(name, &block)
  in_thread(name: name) { loop{self.send(name)} }
end

def solo(name)
  #{:backing_highlights=>1, :backing_highlights2=>4}
  #@named_subthreads
  #HERE LIES EVIL
  #quiet_threads.map(&kill)
end

def fadeout
  vol = 1
  while(vol >= 0) do
	  set_volume! vol
		vol -= 0.08
		sleep 1
	end
end