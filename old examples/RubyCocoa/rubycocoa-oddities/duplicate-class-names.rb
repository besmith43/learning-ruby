#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'osx/cocoa'

# Both C classes are the same:

# /System/Library/Frameworks/RubyCocoa.framework/Resources/ruby/osx/objc/oc_import.rb:266:
# warning: Cannot create Objective-C class for Ruby class `C', because
# another class is already registered in Objective-C with the same
# name. Using the existing class instead for the Ruby class
# representation.
# objc[2776]: objc_registerClassPair: class 'C' was already registered!


module One
  class C < OSX::NSObject
  end
end

module Another
  class C < OSX::NSObject
  end
end
