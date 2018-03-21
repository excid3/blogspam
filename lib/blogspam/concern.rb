module Blogspam
  module Concern
    extend ActiveSupport::Concern

    included do
      scope :clean, ->{ where(is_spam: [nil, false]) }
      scope :spam,  ->{ where(is_spam: true) }

      after_create :check_spam!
    end

    def blogspam_args
      raise NotImplementedError, "You need to implement `blogspam_args` in your model to pass in the attributes blogspam can use to analyze the comment."
    end

    def check_spam!
      response = Blogspam.check_spam(blogspam_args)

      if response["result"] == "SPAM"
        update!(is_spam: true, spam_reason: response["reason"])
      end
    end
  end
end
