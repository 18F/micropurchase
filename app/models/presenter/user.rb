module Presenter
  class User < SimpleDelegator
    def github_json_url
      "https://api.github.com/user/#{github_id}"
    end

    def admin?
      Admins.verify?(model.github_id)
    end

    def sam_account?
      model.sam_account
    end

    def to_param
      model.to_param
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
