def csample(name)
  root = "/Users/josephwilk/Dropbox/repl-electric/samples/pi"
  "#{root}/#{name}"
end

def fadeout
  vol = 1
  while(vol >= 0) do
	  set_volume! vol
		vol -= 0.08
		sleep 1
	end
end