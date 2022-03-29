require 'structured_document'
require 'structured_doc_def_method'
require 'pp'


class Instructions < StructuredDocument 
  paragraph_type( :introduction, 
    :font_name => :arial,
    :font_size => 18,
    :font_emphasis => :bold ) 

  # And so on... 
end


describe Instructions do
  it 'should have the proper methods' do
    Instructions.instance_methods.should include( :introduction )
  end

  it 'should produce working instruction instances' do
    i = Instructions.new( 'building a house', 'russ' )
    i.introduction( 'This is how you build a house' )
    i.introduction( 'carefully' )

    i.paragraphs.first.text.should match(/This is how/)
    i.paragraphs.last.font_size.should == 18
    i.paragraphs.last.font_emphasis.should == :bold
  end

end
