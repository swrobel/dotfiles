require 'irb/ext/save-history'
IRB.conf[:HISTORY_FILE] = "#{Dir.pwd}/.irb-history"
IRB.conf[:SAVE_HISTORY] = 200

# Project-specific .irbrc 
if Dir.pwd != File.expand_path("~")
  local_irbrc = File.expand_path '.irbrc'
  if File.exist? local_irbrc
    puts "Loading #{local_irbrc}"
    load local_irbrc
  end
end

