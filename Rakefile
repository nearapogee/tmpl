# -*- ruby -*-

require "rubygems"
require "hoe"

# Hoe.plugin :compiler
# Hoe.plugin :gem_prelude_sucks
# Hoe.plugin :inline
# Hoe.plugin :racc
# Hoe.plugin :rcov
# Hoe.plugin :rubyforge
Hoe.plugin :minitest
Hoe.plugin :git
Hoe.plugin :isolate

Hoe.spec "tmpl" do
  developer("Matt Smith", "matt@nearapogee.com")

  dependency('rails', '> 1.0.0')
  dependency('hoe-git', '~> 1.6.0', :dev)
  dependency('isolate', '~> 3.2.4', :dev)
  dependency('minitest', '~> 4.7.5', :dev)

  license "MIT"
end

# vim: syntax=ruby