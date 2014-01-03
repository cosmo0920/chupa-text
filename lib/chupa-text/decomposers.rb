# Copyright (C) 2013  Kouhei Sutou <kou@clear-code.com>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

require "chupa-text/decomposer-registry"

module ChupaText
  module Decomposers
    class << self
      def load
        $LOAD_PATH.each do |load_path|
          next unless File.directory?(load_path)
          Dir.chdir(load_path) do
            Dir.glob("chupa-text/decomposers/*.rb") do |decomposer_path|
              require decomposer_path.gsub(/\.rb\z/, "")
            end
          end
        end
      end

      def create(registry, configuration)
        enabled_names = resolve_names(registry, configuration.names)
        enabled_names.collect do |enabled_name|
          decomposer_class = registry.find(enabled_name)
          options = configuration.options[name] || {}
          decomposer_class.new(options)
        end
      end

      private
      def resolve_names(registry, enabled_names)
        resolved_names = []
        flag = 0
        flag |= File::FNM_EXTGLOB if File.const_defined?(:FNM_EXTGLOB)
        enabled_names.each do |enabled_name|
          registry.each do |name,|
            next unless File.fnmatch(enabled_name, name, flag)
            resolved_names << name
          end
        end
        resolved_names
      end
    end
  end
end
