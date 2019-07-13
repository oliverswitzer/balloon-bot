require "celluloid" unless defined? Celluloid

module Celluloid
  module Extras
    # Concurrent Hash mirroring the existing Hash API as an Actor.
    class Hash
      include Celluloid

      def initialize(starter={})
        @outer = starter
      end

      def [](k)
        @outer[k]
      end

      def []=(k, v)
        @outer.store(k, v)
        v
      end

      def key?(k)
        @outer.key?(k)
      end

      def inspect
        @outer.inspect
      end

      def insert(k, v)
        @outer[k] = v
      end

      def merge(h)
        @outer.merge(h)
      end

      def merge!(h)
        @outer.merge!(h)
      end

      def delete(k)
        @outer.delete(k)
      end

      def each(&b)
        @outer.each(&b)
      end

      def sort_by(&b)
        @outer.sort_by(&b)
      end

      def inject(s=nil, &b)
        @outer.inject(s, &b)
      end

      def select!(&b)
        @outer.select!(&b)
      end

      def select(&b)
        @outer.select(&b)
      end

      def replace(h)
        @outer.replace(h)
      end

      def empty?
        @outer.count == 0
      end

      def any?
        @outer.any?
      end

      def count
        @outer.count
      end

      def keys
        @outer.keys
      end
    end
  end
end
