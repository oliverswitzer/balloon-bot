require "forwardable"

module Celluloid
  module Sync
    class << self
      undef gem_path rescue nil
      def gem_path
        File.expand_path("../../", __FILE__)
      end

      undef gem_name rescue nil
      def gem_name
        Dir["#{File.expand_path('../../', __FILE__)}/*.gemspec"].first.gsub(".gemspec", "").split("/").last
      end

      undef gem_name? rescue nil
      def gem_name?
        !gem_name.nil?
      end

      undef lib_path rescue nil
      def lib_path
        File.expand_path("../../lib", __FILE__)
      end

      undef lib_gempath rescue nil
      def lib_gempath
        "#{lib_path}/#{gem_name.split('-').join('/')}"
      end

      undef scenario rescue nil
      def scenario
        File.basename($PROGRAM_NAME)
      end

      undef bundler? rescue nil
      def bundler?
        scenario == "bundle"
      end
    end

    fail "Missing gemspec." unless gem_name?
    $LOAD_PATH.push(gem_path)
    $LOAD_PATH.push(lib_path)

    # TODO: This will likely need to be done differently if INSIDE a cut gem.
    if scenario == "bundle"
      `cd #{gem_path}/culture; git pull origin master` if ARGV.first == "update"
    end

    require("#{gem_path}/culture/gems/loader")
    if File.exist?(version = "#{lib_gempath}/version.rb")
      require(version)
    end
  end
end
