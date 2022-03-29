require 'openssl'

class String
  def encrypt(key)
    cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt
    cipher.key = Digest::SHA1.hexdigest key
    s = cipher.update(self) + cipher.final

    s.unpack('H*')[0].upcase
  end

  def decrypt(key)
    cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').decrypt
    cipher.key = Digest::SHA1.hexdigest key
    s = [self].pack("H*").unpack("C*").pack("c*")

    cipher.update(s) + cipher.final
  end
end


puts plain = 'confidential'           # confidential
puts key = 'secret'                   # secret
puts cipher = plain.encrypt(key)      # 5C6D4C5FAFFCF09F271E01C5A132BE89

puts cipher.decrypt('guess')          # raises OpenSSL::Cipher::CipherError
puts cipher.decrypt(key)              # confidential
