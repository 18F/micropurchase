module Presenter
  class VeiledBidder
    include ActiveModel::SerializerSupport

    def initialize(message: nil)
      @message
    end

    def id
      @message
    end

    def created_at
      @message
    end

    def updated_at
      @message
    end

    def github_id
      @message
    end

    def duns_number
      @message
    end

    def name
      @message
    end

    def email
      @message
    end

    def sam_account
      @message
    end
  end
end
