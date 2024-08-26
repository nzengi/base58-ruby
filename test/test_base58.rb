require 'test/unit'
require 'base58'

class TestBase58 < Test::Unit::TestCase
  def setup
    @examples = {
      flickr: {
        "6hKMCS" => 3471391110,
        "7xBSG3j7NgPksBpPnX1G7y19EuAy4swQexDoECfWdys" => 98765432198765432198765432198765
      },
      bitcoin: {
        "6Hknds" => 3471391110,
        "7Ycsh3K7oGpLTcQpNx1h7Z19fVbZ4TXqEYePfdFwDZT" => 98765432198765432198765432198765
      },
      ripple: {
        "aHk8d1" => 3471391110,
        "fYc16sKfoGFLTcQF4xr6fZr9CVbZhTXqNYePCdEADZT" => 98765432198765432198765432198765
      }
    }
  end

  def test_int_to_base58
    @examples.each do |alphabet, cases|
      cases.each do |expected, integer|
        assert_equal(expected, Base58.int_to_base58(integer, alphabet))
      end
    end
  end

  def test_base58_to_int
    @examples.each do |alphabet, cases|
      cases.each do |base58, expected|
        assert_equal(expected, Base58.base58_to_int(base58, alphabet))
      end
    end
  end

  def test_binary_to_base58
    binary_example = "\x01\xAD<l'\xAF!\x96N\x93u\x93\xE2\xAF\x92p\x96=\x89n\xD7\x953\x17\x12\x8E\xBD\xA2\x04\x84~Z".force_encoding('BINARY')
    assert_equal("7xBSG3j7NgPksBpPnX1G7y19EuAy4swQexDoECfWdys", Base58.binary_to_base58(binary_example, :flickr))
  end

  def test_base58_to_binary
    base58_example = "7xBSG3j7NgPksBpPnX1G7y19EuAy4swQexDoECfWdys"
    expected_binary = "\x01\xAD<l'\xAF!\x96N\x93u\x93\xE2\xAF\x92p\x96=\x89n\xD7\x953\x17\x12\x8E\xBD\xA2\x04\x84~Z".force_encoding('BINARY')
    assert_equal(expected_binary, Base58.base58_to_binary(base58_example, :flickr))
  end
end
