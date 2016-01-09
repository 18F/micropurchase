module Presenter
  class User < SimpleDelegator
    def github_json_url
      "https://api.github.com/user/#{github_id}"
    end

    def admin?
      Admins.verify?(model.github_id)
    end

    def save_sam_status
      return if sam_account?
      self.sam_account = registered_on_sam?
      save!
    end
        
    def clear_sam_status_if_duns_changed
      self.sam_account = false if persisted? && duns_number_changed?
      true
    end

    def registered_on_sam?
      self.class.registered_on_sam?(duns: duns_number)
    end

    def self.registered_on_sam?(duns: nil)
      client = Samwise::Client.new
      client.duns_is_in_sam?(duns: duns)
    end

    def model
      __getobj__
    end
  end
end
