#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
Inflector.inflections do |inflect|
  inflect.plural(/$/, 's')
  inflect.plural(/s$/i, 's')
  inflect.plural(/(ax|test)is$/i, '\1es')
  inflect.plural(/(octop|vir)us$/i, '\1i')
  inflect.plural(/(alias|status)$/i, '\1es')
  inflect.plural(/(bu)s$/i, '\1ses')
  inflect.plural(/(buffal|tomat)o$/i, '\1oes')
  inflect.plural(/([ti])um$/i, '\1a')
  inflect.plural(/sis$/i, 'ses')
  inflect.plural(/(?:([^f])fe|([lr])f)$/i, '\1\2ves')
  inflect.plural(/(hive)$/i, '\1s')
  inflect.plural(/([^aeiouy]|qu)y$/i, '\1ies')
  inflect.plural(/(x|ch|ss|sh)$/i, '\1es')
  inflect.plural(/(matr|vert|ind)ix|ex$/i, '\1ices')
  inflect.plural(/([m|l])ouse$/i, '\1ice')
  inflect.plural(/^(ox)$/i, '\1en')
  inflect.plural(/(quiz)$/i, '\1zes')

  inflect.singular(/s$/i, '')
  inflect.singular(/(n)ews$/i, '\1ews')
  inflect.singular(/([ti])a$/i, '\1um')
  inflect.singular(/((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$/i, '\1\2sis')
  inflect.singular(/(^analy)ses$/i, '\1sis')
  inflect.singular(/([^f])ves$/i, '\1fe')
  inflect.singular(/(hive)s$/i, '\1')
  inflect.singular(/(tive)s$/i, '\1')
  inflect.singular(/([lr])ves$/i, '\1f')
  inflect.singular(/([^aeiouy]|qu)ies$/i, '\1y')
  inflect.singular(/(s)eries$/i, '\1eries')
  inflect.singular(/(m)ovies$/i, '\1ovie')
  inflect.singular(/(x|ch|ss|sh)es$/i, '\1')
  inflect.singular(/([m|l])ice$/i, '\1ouse')
  inflect.singular(/(bus)es$/i, '\1')
  inflect.singular(/(o)es$/i, '\1')
  inflect.singular(/(shoe)s$/i, '\1')
  inflect.singular(/(cris|ax|test)es$/i, '\1is')
  inflect.singular(/(octop|vir)i$/i, '\1us')
  inflect.singular(/(alias|status)es$/i, '\1')
  inflect.singular(/^(ox)en/i, '\1')
  inflect.singular(/(vert|ind)ices$/i, '\1ex')
  inflect.singular(/(matr)ices$/i, '\1ix')
  inflect.singular(/(quiz)zes$/i, '\1')

  inflect.irregular('person', 'people')
  inflect.irregular('man', 'men')
  inflect.irregular('child', 'children')
  inflect.irregular('sex', 'sexes')
  inflect.irregular('move', 'moves')

  inflect.uncountable(%w(equipment information rice money species series fish sheep))
end

module Inflections #:nodoc:

  def pluralize
    Inflector.pluralize(self)
  end

  def singularize
    Inflector.singularize(self)
  end

  def camelize(first_letter = :upper)
    case first_letter
      when :upper then Inflector.camelize(self, true)
      when :lower then Inflector.camelize(self, false)
    end
  end
  alias_method :camelcase, :camelize

  def titleize
    Inflector.titleize(self)
  end
  alias_method :titlecase, :titleize

  def underscore
    Inflector.underscore(self)
  end

  def dasherize
    Inflector.dasherize(self)
  end

  def demodulize
    Inflector.demodulize(self)
  end

  def tableize
    Inflector.tableize(self)
  end

  def classify
    Inflector.classify(self)
  end

  def humanize
    Inflector.humanize(self)
  end

  def foreign_key(separate_class_name_and_id_with_underscore = true)
    Inflector.foreign_key(self, separate_class_name_and_id_with_underscore)
  end

  def constantize
    Inflector.constantize(self)
  end
end

class String
  include Inflections
end