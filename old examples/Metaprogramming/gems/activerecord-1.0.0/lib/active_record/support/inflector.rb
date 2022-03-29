#---
# Excerpted from "Metaprogramming Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/ppmetr2 for more book information.
#---
# The Inflector transforms words from singular to plural, class names to table names, modulized class names to ones without,
# and class names to foreign keys.
module Inflector 
  extend self

  def pluralize(word)
    result = word.dup
    plural_rules.each do |(rule, replacement)|
      break if result.gsub!(rule, replacement)
    end
    return result
  end

  def singularize(word)
    result = word.dup
    singular_rules.each do |(rule, replacement)|
      break if result.gsub!(rule, replacement)
    end
    return result
  end

  def camelize(lower_case_and_underscored_word)
    lower_case_and_underscored_word.gsub(/(^|_)(.)/){$2.upcase}
  end
  
  def underscore(camel_cased_word)
    camel_cased_word.gsub(/([A-Z]+)([A-Z])/,'\1_\2').gsub(/([a-z])([A-Z])/,'\1_\2').downcase
  end

  def demodulize(class_name_in_module)
    class_name_in_module.gsub(/^.*::/, '')
  end

  def foreign_key(class_name, separate_class_name_and_id_with_underscore = true)
    Inflector.underscore(Inflector.demodulize(class_name)) + 
      (separate_class_name_and_id_with_underscore ? "_id" : "id")
  end
  
  private
    def plural_rules #:doc:
      [
        [/(x|ch|ss)$/, '\1es'],               # search, switch, fix, box, process, address
        [/([^aeiouy]|qu)y$/, '\1ies'],        # query, ability, agency
        [/(?:([^f])fe|([lr])f)$/, '\1\2ves'], # half, safe, wife
        [/sis$/, 'ses'],                      # basis, diagnosis
        [/([ti])um$/, '\1a'],                 # datum, medium
        [/person$/, 'people'],                # person, salesperson
        [/man$/, 'men'],                      # man, woman, spokesman
        [/child$/, 'children'],               # child
        [/s$/, 's'],                          # no change (compatibility)
        [/$/, 's']
      ]
    end

    def singular_rules #:doc:
      [
          [/(x|ch|ss)es$/, '\1'],
          [/([^aeiouy]|qu)ies$/, '\1y'],
          [/([lr])ves$/, '\1f'],
          [/([^f])ves$/, '\1fe'],
          [/(analy|ba|diagno|parenthe|progno|synop|the)ses$/, '\1sis'],
          [/([ti])a$/, '\1um'],
          [/people$/, 'person'],
          [/men$/, 'man'],
          [/status$/, 'status'],
          [/children$/, 'child'],
          [/s$/, '']
        ]
    end
end