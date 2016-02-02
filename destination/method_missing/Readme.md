```
                                                                
           /    /            |           /           /          
 _ _  ___ (___ (___  ___  ___|      _ _    ___  ___    ___  ___ 
| | )|___)|    |   )|   )|   )     | | )| |___ |___ | |   )|   )
|  / |__  |__  |  / |__/ |__/      |  / |  __/  __/ | |  / |__/ 
                               ---                         __/  
```

```ruby
module MissingMethod
  def self.method_missing(where, *are, &you)
    missing
  end
end

MissingMethod.where_are_you?
```
