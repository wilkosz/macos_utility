#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'macos_utility'

p MacosUtility.get_processes(process_id: 21141)