Spring.watch_method = :listen

%w(.ruby-version tmp/caching.txt tmp/restart.txt).each { |path| Spring.watch path }
