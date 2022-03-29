require '../code/doc3'

ENCRYPTION_ENABLED = true       ##(main

class Document

   # Most of the class left behind...

  def self.enable_encryption( enabled )
    if enabled 
      def encrypt_string( string )
        string.tr( 'a-zA-Z', 'm-za-lM-ZA-L')
      end
    else
      def encrypt_string( string )
        string
      end
    end
  end
                                         
  enable_encryption( ENCRYPTION_ENABLED )
end                             ##main)
