module Tmpl
  VERSION = "1.0.0.pre1"
end

Dir.glob(File.dirname(__FILE__) + '/tmpl/*.rb') { |file| require file }
