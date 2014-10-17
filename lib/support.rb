def csample(name)
  root = "/Users/josephwilk/Dropbox/repl-electric/samples/pi"
  sample_path = "#{root}/#{name}"
#  load_sample sample_path
  sample_path
end

def with_echo(args, &block)
  with_fx :echo do
    block
  end
end

def live(name, &block)
  raise "live_loop must be called with a code block" unless block
  (@__live_cache ||= []) << name
  @__live_cache = @__live_cache.uniq

  define(name, &block)

  in_thread(name: name) do
    n = 0
    loop do
      cue name
      if self.method(name).arity >= 1
        send(name, n)
      else
        send(name)
      end
      n += 1
    end
  end
end

def begone(name)
  raise "could not find #{name} to silence" unless @user_methods.method_defined?(name)

  __info "Silencing #{name}"

  define(name) do |*args|
    sleep 1
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
