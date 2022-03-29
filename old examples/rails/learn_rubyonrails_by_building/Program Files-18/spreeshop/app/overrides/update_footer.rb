Deface::Override.new(:virtual_path => 'spree/shared/_footer', 
	:name => 'change footer phone number',
	:replace => 'div.phone',
	:text => '<div class="phone">
				(555) 555-5555
			  </div>'
)

Deface::Override.new(:virtual_path => 'spree/shared/_footer', 
	:name => 'change footer email',
	:replace => 'div.email',
	:text => '<div class="email">
				something@something.com
			  </div>'
)

Deface::Override.new(:virtual_path => 'spree/shared/_footer', 
	:name => 'change footer address',
	:replace => 'div.address',
	:text => '<div class="address">
				444 Main st, Unit 3<br>
				Boston MA 01912
			  </div>'
)