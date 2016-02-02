```
                                                                
           /    /            |           /           /          
 _ _  ___ (___ (___  ___  ___|      _ _    ___  ___    ___  ___ 
| | )|___)|    |   )|   )|   )     | | )| |___ |___ | |   )|   )
|  / |__  |__  |  / |__/ |__/      |  / |  __/  __/ | |  / |__/ 
                               ---                         __/  
```

```ruby
module MissingMethod
  def self.method_missing(method_sym, *arguments, &block)
    missing
  end
end

MissingMethod.where_are_you?
```
