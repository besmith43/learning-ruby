#---
# Excerpted from "Metaprogramming Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/ppmetr2 for more book information.
#---
#require File.dirname(__FILE__) + '/../dev-utils/eval_debugger'
require 'abstract_unit'
require 'fixtures/topic'
require 'fixtures/customer'
require 'fixtures/company'
require 'fixtures/company_in_module'

class ReflectionTest < Test::Unit::TestCase
  def setup
    @topics = create_fixtures "topics"
    @customers = create_fixtures "customers"
    @companies = create_fixtures "companies"
    @first = Topic.find(1)
  end

  def test_read_attribute_names
    assert_equal(
      %w( id title author_name author_email_address written_on last_read content approved replies_count parent_id type ).sort,
      @first.attribute_names
    )
  end
  
  def test_columns
    assert_equal 11, Topic.columns.length
  end

  def test_content_columns
    assert_equal 7, Topic.content_columns.length
  end
  
  def test_column_string_type_and_limit
    assert_equal :string, @first.column_for_attribute("title").type
    assert_equal 255, @first.column_for_attribute("title").limit
  end

  def test_human_name_for_column
    assert_equal "Author name", @first.column_for_attribute("author_name").human_name
  end
  
  def test_integer_columns
    assert_equal :integer, @first.column_for_attribute("id").type
  end  

  def test_aggregation_reflection
    reflection_for_address = ActiveRecord::Reflection::AggregateReflection.new(
      :address, { :mapping => [ %w(address_street street), %w(address_city city), %w(address_country country) ] }, Customer
    )

    reflection_for_balance = ActiveRecord::Reflection::AggregateReflection.new(
      :balance, { :class_name => "Money", :mapping => %w(balance amount) }, Customer
    )

    assert_equal(
      [ reflection_for_address, reflection_for_balance ],
      Customer.reflect_on_all_aggregations
    )
    
    assert_equal reflection_for_address, Customer.reflect_on_aggregation(:address)
    
    assert_equal Address, Customer.reflect_on_aggregation(:address).klass
  end
  
  def test_association_reflection
    reflection_for_clients = ActiveRecord::Reflection::AssociationReflection.new(
      :clients, { :order => "id", :dependent => true }, Firm
    )

    assert_equal reflection_for_clients, Firm.reflect_on_association(:clients)

    assert_equal Client, Firm.reflect_on_association(:clients).klass
    assert_equal Client, Firm.reflect_on_association(:clients_of_firm).klass
  end
  
  def test_association_reflection_in_modules
    assert_equal MyApplication::Business::Client, MyApplication::Business::Firm.reflect_on_association(:clients_of_firm).klass
    assert_equal MyApplication::Business::Firm, MyApplication::Billing::Account.reflect_on_association(:firm).klass
  end
end