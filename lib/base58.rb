class Base58
    ALPHABETS = {
      flickr: "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ",  # Default alphabet
      bitcoin: "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz",  # Bitcoin/IPFS alphabet
      ripple: "rpshnaf39wBUDNEGHJKLM4PQRST7VWXYZ2bcdeCg65jkm8oFqi1tuvAxyz"   # Ripple alphabet
    }
  
    # Converts a base58 string to a base10 integer.
    def self.base58_to_int(base58_val, alphabet = :flickr)
      validate_alphabet!(alphabet)
      int_val = 0
      base58_val.reverse.each_char.with_index do |char, index|
        char_index = ALPHABETS[alphabet].index(char)
        raise ArgumentError, 'Invalid Base58 String.' if char_index.nil?
        int_val += char_index * (ALPHABETS[alphabet].length ** index)
      end
      int_val
    end
  
    # Converts a base10 integer to a base58 string.
    def self.int_to_base58(int_val, alphabet = :flickr)
      validate_integer!(int_val)
      validate_alphabet!(alphabet)
      return ALPHABETS[alphabet][0] if int_val == 0
  
      base58_val = ''
      base_length = ALPHABETS[alphabet].length
      while int_val > 0
        mod = int_val % base_length
        base58_val = ALPHABETS[alphabet][mod] + base58_val
        int_val /= base_length
      end
      base58_val
    end
  
    # Converts binary string to a base58 string.
    def self.binary_to_base58(binary_val, alphabet = :flickr, include_leading_zeroes = true)
      validate_binary!(binary_val)
      validate_alphabet!(alphabet)
      return int_to_base58(0, alphabet) if binary_val.empty?
  
      leading_zeroes = include_leading_zeroes ? binary_val.bytes.take_while { |b| b == 0 }.size : 0
      int_val = binary_val.unpack1('H*').to_i(16)
      prefix = ALPHABETS[alphabet][0] * leading_zeroes
      prefix + int_to_base58(int_val, alphabet)
    end
  
    # Converts a base58 string to a binary string.
    def self.base58_to_binary(base58_val, alphabet = :flickr)
      validate_alphabet!(alphabet)
      int_val = base58_to_int(base58_val, alphabet)
      binary_val = [int_val.to_s(16)].pack('H*')
      leading_zeroes = base58_val.each_char.take_while { |c| c == ALPHABETS[alphabet][0] }.size
      ("\x00" * leading_zeroes) + binary_val
    end
  
    private
  
    def self.validate_alphabet!(alphabet)
      raise ArgumentError, 'Invalid alphabet selection.' unless ALPHABETS.key?(alphabet)
    end
  
    def self.validate_integer!(value)
      raise ArgumentError, 'Value is not an Integer.' unless value.is_a?(Integer)
    end
  
    def self.validate_binary!(value)
      raise ArgumentError, 'Value is not a binary string.' unless value.encoding == Encoding::BINARY
    end
  
    class << self
      alias encode int_to_base58
      alias decode base58_to_int
    end
  end
  