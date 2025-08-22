# DataMapper dependencies
require 'stringio'
require 'logger'

# Bundle dependencies
require 'bundler/setup'
require 'bundler'
Bundler.require

# Zeitwerk
require './config/zeitwerk'

# Load environment variables
require 'dotenv'
Dotenv.load

# Database configuration
require 'dm-core'
DataMapper.logger = ::Logger.new($stdout)
DataMapper.logger.level = :debug
DataMapper.setup(:default, ENV['DATABASE_URL'])
DataMapper::Model.raise_on_save_failure = true
DataMapper.finalize


require 'active_support'
require 'active_support/time'
require 'active_support/core_ext'
ENV['TZ'] = 'UTC'
