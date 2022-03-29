#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
module PermanentlyIdentifiable

  # To be called within designated initializer
  def become_permanently_identifiable
    # globallyUniqueString() contains timestamp, so no danger of
    # duplication next time process starts. 
    @_identity_guid = NSProcessInfo.processInfo.globallyUniqueString
  end

  # To be called inside encodeWithCoder
  def encode_permanent_identity(coder)
    coder.encodeObject @_identity_guid, forKey: 'guid for permanent identity'
  end

  # To be called inside initWithCoder
  def decode_permanent_identity(coder)
    @_identity_guid = coder.decodeObjectForKey('guid for permanent identity')
  end

  def was_originally_identically?(other)
    other.has_same_original_identity?(@_identity_guid)
  end

  def has_same_original_identity?(guid)
    @_identity_guid == guid
  end
end
