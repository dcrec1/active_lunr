require 'fileutils'
 
src = File.join(File.dirname(__FILE__), 'lunr.yml')
target = File.join(File.dirname(__FILE__), '..', '..', '..', 'config', 'lunr.yml')

FileUtils.cp src, target