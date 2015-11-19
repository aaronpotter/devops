# (c) 2015 Univision Communications Inc.  All rights reserved.

require 'digest/sha1'
require 'base64'

# fucking words for ruby linting
class Htpasswd
  SALT_CHARS = (%w[ . / ] + ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a).freeze

  def initialize(password)
    @password = password
  end

  def sha1
    "{SHA}#{Base64.encode64(::Digest::SHA1.digest(@password)).strip}"
  end

  def crypt
    @password.crypt(gen_salt)
  end

  private

  # 8 bytes of random items from SALT_CHARS
  def gen_salt
    chars = []
    8.times do
      chars << SALT_CHARS[rand(SALT_CHARS.size)]
    end
    chars.join('')
  end
end
