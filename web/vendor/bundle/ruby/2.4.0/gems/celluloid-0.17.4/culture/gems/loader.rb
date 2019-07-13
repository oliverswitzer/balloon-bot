require "yaml"

module Celluloid
  module Sync
    module Gemfile
      class << self
        def [](dsl)
          dsl.source("https://rubygems.org")
          dsl.gemspec # Runs gemspec, but also @sets gem_name.
          Gems.gemfile(dsl)
        end
      end
    end
    module Gemspec
      class << self
        def [](gem)
          Gems.gemspec(gem)
        end
      end
    end
  end
  module Gems
    extend self
    @gem_name = nil

    undef gems rescue nil
    def gems
      File.expand_path("../dependencies.yml", __FILE__)
    end

    unless @dependencies ||= nil
      @dependencies = YAML.load_file(gems) if File.exist?(gems)
    end

    unless @dependencies.is_a?(Hash) && @dependencies.any?
      fail "Celluloid cannot find its dependencies."
    end

    undef core? rescue nil
    def core?(name=@gem_name)
      return false unless @dependencies[name].is_a? Hash
      @dependencies[name]["dependency"] == "core"
    end

    undef separate? rescue nil
    def separate?
      !@dependencies.keys.include?(@gem_name)
    end

    undef gemspec rescue nil
    def gemspec(gem)
      @gem_name = gem.name
      loader do |name, spec|
        # Rules for dependencies, to avoid so-called circular dependency:
        # - Only the core gem lists all the modules as runtime dependencies.
        # - If this gem is not in the dependencies list, then it needs the core gem at runtime;
        #   the module gems are development dependencies only. This is a depending separate gem.
        #   There is the core gem, module gems, true dependencies, and separately depending gems.
        # - If the dependency is a module, it is only a development dependency to other modules,
        #   and even the core gem is a development dependency. It is not expected to be used alone.
        meth = case spec["dependency"]
               when "core", "module"
                 # For the core gem, all modules are runtime dependencies.
                 # For separate gems, only the core gem is a runtime dependency.
                 if core? || (separate? && core?(name))
                   :add_runtime_dependency
                 else
                   :add_development_dependency
                 end
               when "development"
                 :add_development_dependency
               else
                 :add_dependency
               end
        gem.send(meth, name, spec["version"] || ">= 0")
      end
    end

    undef gemfile rescue nil
    def gemfile(dsl)
      loader do |name, spec|
        params = [name, spec["version"] || ">= 0"]
        req = spec["gemfile"] || {}
        params << req.each_with_object({}) { |(k, v), o| o[k.to_sym] = v }
        current = dsl.dependencies.find { |d| d.name == name }
        dsl.dependencies.delete(current) if current
        dsl.gem(*params)
      end
    end

    private

    def loader
      @dependencies.each do |name, spec|
        next if name == @gem_name
        spec ||= {}
        yield name, spec
      end
    end
  end
end
