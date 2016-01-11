module Presenter
  class User < SimpleDelegator
    def github_json_url
      "https://api.github.com/user/#{github_id}"
    end

    def admin?
      Admins.verify?(model.github_id)
    end

    def in_sam?
      if model.sam_account == true
        'Yes'
      else
        'No'
      end
    end

    def model
      __getobj__
    end
  end
end
