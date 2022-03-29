require 'logger'

$LOG = Logger.new('log_file.log', 'monthly')  
def divide(numerator, denominator)  
	  $LOG.debug("Numerator: #{numerator}, denominator #{denominator}")  
	    begin  
			result = numerator / denominator  
		rescue Exception => e  
			$LOG.error "Error in division!: #{e}"  
			result = nil  	
		end  
	return result  
end  
divide(10, 2)  
divide(10, 0)
