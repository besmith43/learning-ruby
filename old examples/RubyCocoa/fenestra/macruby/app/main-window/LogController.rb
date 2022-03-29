#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
class LogController < Controller

  attr_writer :log

  def awakeFromNib
    @log.clear
    super
  end

=begin
  on_local_notification AppChosen do | notification |
    $stderr.puts "AppChosen in LogController"
    @log.addLine("hi")
#    original = notification.userInfo[:app_name]
    original = NSMutableString.stringWithString(notification.userInfo[:app_name])
    calculated = original + ""
#    calculated = "#{notification.userInfo[:app_name]}"
    $stderr.puts original.class
    $stderr.puts calculated.class

    $stderr.puts "original == calculated? #{original==calculated}"
    $stderr.puts "original.compare = calculated? #{original.compare(calculated)}"

    index = 0
    $stderr.puts "value of char #{index} in original:"
    $stderr.puts original[index].inspect
    $stderr.puts original.characterAtIndex(index).inspect
    $stderr.puts "value of char #{index} in calculated:"
    $stderr.puts calculated[index].inspect
    $stderr.puts calculated.characterAtIndex(index).inspect
    exit

    $stderr.puts "====="
    $stderr.puts original.length
    index = 1
#    $stderr.puts calculated[20].inspect
#    $stderr.puts calculated.characterAtIndex(21).inspect
    substring = calculated.substringToIndex(index)
    $stderr.puts "substring: #{substring}"
    @log.addLine "substring is a #{substring.class}"
    @log.addLine(substring)
    $stderr.puts "====="
    
    substring = calculated.substringToIndex(index)
    $stderr.puts "substring: #{substring}"
    @log.addLine "substring is a #{substring.class}"
    @log.addLine(substring)


    hardcoded = "sample webapp com.exampler.counting"
    $stderr.puts "calculated == hardcoded? #{calculated==hardcoded}"
    $stderr.puts "calculated.compare = hardcoded? #{calculated.compare(hardcoded)}"
    $stderr.puts "calculated.length = #{calculated.length}"
    $stderr.puts "hardcoded.length = #{hardcoded.length}"

    $stderr.puts "====="
    $stderr.puts calculated.length
    index = 21
    $stderr.puts calculated[20].inspect
    $stderr.puts calculated.characterAtIndex(21).inspect
    
    substring = calculated.substringToIndex(index)
    $stderr.puts "substring: #{substring}"
    @log.addLine "substring is a #{substring.class}"
    @log.addLine(substring)
    $stderr.puts "====="

    @log.addLine "Calculated is a #{calculated.class}"
    @log.addLine(calculated)
    @log.addLine "hardcoded is a #{hardcoded.class}"
    @log.addLine(hardcoded)

    $stderr.puts "puts calculated:"
    $stderr.puts calculated
    $stderr.puts "puts hardcoded"
    $stderr.puts hardcoded
#    @log.addLine("Logging started for '#{notification[:app_name]}'...")
  end
=end


  on_local_notification AppChosen do | notification |
    fixed = fix(notification.userInfo[:app_name])  # PORT
    @log.addLine("Logging started for '#{fixed}'...")
  end

  on_local_notification TimeToForgetApp do | notification | 
    fixed = fix(notification.userInfo[:app_name])  # PORT
    @log.addLine("Logging finished for '#{fixed}'.")
  end

  on_local_notification AppFactAvailable do | notification |
    $stderr.puts "AppFactAvailable"
    @log.addLine(notification[:message])
  end


  # PORT: Somehow the original string is corrupt - this fixes it.
  def fix(notification_string)
    NSMutableString.stringWithString(notification_string)
  end
  
end
