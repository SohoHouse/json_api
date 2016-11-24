require 'simplecov-rcov'

SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.root File.expand_path('..', __FILE__)
SimpleCov.add_filter '/gems/'
