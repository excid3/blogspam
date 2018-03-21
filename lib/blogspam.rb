require "blogspam/version"
require "blogspam/concern"

require "http"

module Blogspam
  def self.check_spam(args)
    response = HTTP.post("http://test.blogspam.net:9999/", json: args).parse
  end
end
