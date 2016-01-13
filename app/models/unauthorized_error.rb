class UnauthorizedError < StandardError
  class MustBeAdmin < StandardError
    def initialize(message: 'Must be an admin')
      super(message)
    end
  end

  class UserNotFound < StandardError
    def initialize(message: 'User not found')
      super(message)
    end
  end

  class GitHubAuthenticationError < StandardError
  end
end
