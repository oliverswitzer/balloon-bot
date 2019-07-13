require "celluloid" unless defined? Celluloid

module Celluloid
  module Extras
    class Rehasher
      include Celluloid

      def rehash(string, rounds)
        fail ArgumentError, "hurr" unless rounds > 1
        penultimate = (rounds - 1).times.inject(string) { |a, e| Digest::SHA512.digest(a) }
        Digest::SHA512.hexdigest(penultimate)
      end
    end
  end
end
