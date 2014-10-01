def csample(name)
  root = "/Users/josephwilk/Dropbox/repl-electric/samples/pi"
  "#{root}/#{name}"
end

def with_echo(args, &block)
  with_fx :echo do
    block
  end
end

def live_loop(name, &block)
  raise "live_loop must be called with a code block" unless block
  (@__live_cache ||= []) << name
  @__live_cache = @__live_cache.uniq

  define(name, &block)

  in_thread(name: name) do
    loop do
      cue name
      send(name)
    end
  end
end

def silence(name)
  if @user_methods.method_defined?(name)
    define(name) do |*args|
      sleep 1
    end
  else
    raise "could not find #{name}"
  end
end

def solo(name)
  if @user_methods.method_defined?(name)
    (@__live_cache - [name]).map{|n| silence(n)}
  else
    raise "could not find #{name}"
  end
end

def fadeout
  vol = 1
  while(vol >= 0) do
	  set_volume! vol
		vol -= 0.08
		sleep 1
	end
end
