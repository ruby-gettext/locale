# -*- mode: ruby; coding: utf-8 -*-
#
# Copyright (C) 2012  Kouhei Sutou <kou@clear-code.com>
#
# License: Ruby's or LGPL
#
# This library is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

$:.unshift "./lib"

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require 'rake/gempackagetask'

require "bundler/gem_helper"

#desc "Default Task"
#task :default => [ :test ]

# Run the unit tests
task :test do 
  Dir.glob("test/test_*.rb").each do |v|
    ruby "-Ilib #{v}"
  end
end

Rake::RDocTask.new { |rdoc|
  begin
    allison = `allison --path`.chop
  rescue Exception
    allison = ""
  end
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = "Ruby-Locale library"
  rdoc.options << "--line-numbers" << "--inline-source" <<
      "--accessor" << "cattr_accessor=object" << "--charset" << "utf-8"
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('ChangeLog')
  rdoc.rdoc_files.add('lib')
  rdoc.template = allison if allison.size > 0
}

class Bundler::GemHelper
  undef_method :version_tag
  def version_tag
    version
  end
end

helper = Bundler::GemHelper.new(base_dir)
helper.install
spec = helper.gemspec

unless RUBY_PLATFORM =~ /win32/
  Rake::PackageTask.new("ruby-locale", PKG_VERSION) do |o|
    o.package_files = FileList['**/*'].to_a.select{|v| v !~ /pkg|CVS/}
    o.need_tar_gz = true
    o.need_zip = false
  end
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar_gz = false
  p.need_zip = false
end
