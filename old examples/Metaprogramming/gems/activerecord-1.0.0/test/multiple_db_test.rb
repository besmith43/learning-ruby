#---
# Excerpted from "Metaprogramming Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/ppmetr2 for more book information.
#---
require 'abstract_unit'
require 'fixtures/course'
require 'fixtures/entrant'

class MultipleDbTest < Test::Unit::TestCase
  def setup
    @courses  = create_fixtures("courses") { Course.retrieve_connection }
    @entrants = create_fixtures("entrants")
  end

  def test_connected
    assert_not_nil Entrant.connection
    assert_not_nil Course.connection
  end

  def test_proper_connection
    assert_not_equal(Entrant.connection, Course.connection)
    assert_equal(Entrant.connection, Entrant.retrieve_connection)
    assert_equal(Course.connection, Course.retrieve_connection)
    assert_equal(ActiveRecord::Base.connection, Entrant.connection)
  end

  def test_find
    c1 = Course.find(1)
    assert_equal "Ruby Development", c1.name
    c2 = Course.find(2)
    assert_equal "Java Development", c2.name
    e1 = Entrant.find(1)
    assert_equal "Ruby Developer", e1.name
    e2 = Entrant.find(2)
    assert_equal "Ruby Guru", e2.name
    e3 = Entrant.find(3)
    assert_equal "Java Lover", e3.name
  end

  def test_associations
    c1 = Course.find(1)
    assert_equal 2, c1.entrants_count
    e1 = Entrant.find(1)
    assert_equal e1.course.id, c1.id
    c2 = Course.find(2)
    assert_equal 1, c2.entrants_count
    e3 = Entrant.find(3)
    assert_equal e3.course.id, c2.id
  end
end
