# -*- encoding : ascii-8bit -*-

module Ethereum
  class Address

    def initialize(s)
      @bytes = parse s
    end

    def to_bytes(extended=false)
      extended ? "#{@bytes}#{checksum}" : @bytes
    end

    def checksum(bytes=nil)
      Utils.keccak256(bytes||@bytes)[0,4]
    end

    private

    def parse(s)
      case s.size
      when 40
        Utils.decode_hex s
      when 48
        bytes = Utils.decode_hex s
        parse bytes
      when 20
        s
      when 24
        bytes = s[0...-4]
        raise ChecksumError, "Invalid address checksum!" unless s[-4..-1] == checksum(bytes)
        bytes
      else
        raise FormatError, "Invalid address format!"
      end
    end

  end
end