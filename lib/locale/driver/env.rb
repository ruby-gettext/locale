# -*- coding: utf-8 -*-
#
# Copyright (C) 2012  Kouhei Sutou <kou@clear-code.com>
# Copyright (C) 2012  Hleb Valoshka
# Copyright (C) 2008  Masao Mutoh
#
# Original: Ruby-GetText-Package-1.92.0.
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

require 'locale/tag'
require 'locale/taglist'
require "locale/driver"

module Locale
  module Driver
    # Locale::Driver::Env module.
    # Detect the user locales and the charset.
    # All drivers(except CGI) refer environment variables first and use it
    # as the locale if it's defined.
    # This is a low-level module. Application shouldn't use this directly.
    module Env
      module_function

      # Gets the locale from environment variable. (LC_ALL > LC_CTYPE > LANG)
      # Returns: the locale as Locale::Tag::Posix.
      def locale
        # At least one environment valiables should be set on *nix system.
        [ENV["LC_ALL"], ENV["LC_CTYPE"], ENV["LANG"]].each do |loc|
          if loc != nil and loc.size > 0
            return Locale::Tag::Posix.parse(loc)
          end
        end
        nil
      end

      # Gets the locales from environment variables. (LANGUAGE > LC_ALL > LC_CTYPE > LANG)
      # * Returns: an Array of the locale as Locale::Tag::Posix or nil.
      def locales
        locales = ENV["LANGUAGE"]
        if (locales != nil and locales.size > 0)
          locs = locales.split(/:/).collect{|v| Locale::Tag::Posix.parse(v)}.compact
          if locs.size > 0
            return Locale::TagList.new(locs)
          end
        elsif (loc = locale)
          return Locale::TagList.new([loc])
        end
        nil
      end

      # Gets the charset from environment variable or return nil.
      # * Returns: the system charset.
      def charset  # :nodoc:
        if loc = locale
          loc.charset
        else
          nil
        end
      end
      
    end

    MODULES[:env] = Env
  end
end

