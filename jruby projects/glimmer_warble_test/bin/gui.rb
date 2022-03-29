require 'glimmer-dsl-swt'

include Glimmer

shell {
  #grid_layout

  text "Glimmer"

  minimum_size 480, 320

  background_image File.expand_path('../lib/img/test.png', __dir__)

  label {
    text "Hello World!"
  }
}.open
