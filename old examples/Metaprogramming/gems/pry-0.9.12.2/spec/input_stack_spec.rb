#---
# Excerpted from "Metaprogramming Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/ppmetr2 for more book information.
#---
# coding: utf-8
require 'helper'

describe "Pry#input_stack" do
  before do
    @str_output = StringIO.new
  end

  it 'should accept :input_stack as a config option' do
    stack = [StringIO.new("test")]
    Pry.new(:input_stack => stack).input_stack.should == stack
  end

  it 'should use defaults from Pry.config' do
    Pry.config.input_stack = [StringIO.new("exit")]
    Pry.new.input_stack.should == Pry.config.input_stack
    Pry.config.input_stack = []
  end

  it 'should read from all input objects on stack and exit session (usingn repl)' do
    stack = [b = StringIO.new(":cloister\nexit\n"), c = StringIO.new(":baron\n")]
    instance = Pry.new(:input => StringIO.new(":alex\n"),
                       :output => @str_output,
                       :input_stack => stack)

    instance.repl
    @str_output.string.should =~ /:alex/
    @str_output.string.should =~ /:baron/
    @str_output.string.should =~ /:cloister/
  end

  it 'input objects should be popped off stack as they are used up' do
    stack = [StringIO.new(":cloister\n"), StringIO.new(":baron\n")]
    instance = Pry.new(:input => StringIO.new(":alex\n"),
                       :output => @str_output,
                       :input_stack => stack)

    stack.size.should == 2

    instance.rep
    @str_output.string.should =~ /:alex/
    instance.rep
    @str_output.string.should =~ /:baron/
    stack.size.should == 1
    instance.rep
    @str_output.string.should =~ /:cloister/
    stack.size.should == 0
  end

  it 'should revert to Pry.config.input when it runs out of input objects in input_stack' do
    redirect_pry_io(StringIO.new(":rimbaud\nexit\n"), StringIO.new) do
      stack = [StringIO.new(":cloister\n"), StringIO.new(":baron\n")]
      instance = Pry.new(:input => StringIO.new(":alex\n"),
                         :output => @str_output,
                         :input_stack => stack)

      instance.repl
      @str_output.string.should =~ /:alex/
      @str_output.string.should =~ /:baron/
      @str_output.string.should =~ /:cloister/
      @str_output.string.should =~ /:rimbaud/
    end
  end

  it 'should display error and throw(:breakout) if at end of input after using up input_stack objects' do
    catch(:breakout) do
      redirect_pry_io(StringIO.new(":rimbaud\n"), @str_output) do
        Pry.new(:input_stack => [StringIO.new(":a\n"), StringIO.new(":b\n")]).repl
      end
    end
    @str_output.string.should =~ /Error: Pry ran out of things to read/
  end

  if "".respond_to?(:encoding)
    after do
      Pry.line_buffer = [""]
      Pry.current_line = 1
    end
    it "should pass strings to Pry in the right encoding" do
      input1 = "'f??????'.encoding.name" # utf-8, see coding declaration
      input2 = input1.encode('Shift_JIS')

      mock_pry(input1, input2).should == %{=> "UTF-8"\n=> "Shift_JIS"\n\n}
    end

    it "should be able to use unicode regexes on a UTF-8 terminal" do
      mock_pry('":-??" =~ /??/i').should == %{=> 2\n\n}
    end
  end
end
