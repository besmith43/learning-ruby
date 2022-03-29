# 4_look_and_feel_options.rb

java_import  javax.swing.UIManager

UIManager.get_installed_look_and_feels().each do |info|
  puts info.get_name()
end
