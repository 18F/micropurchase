module ActionDispatch
  module Http
    module URL
      # monkey-patching
      # https://github.com/rails/rails/blob/fe1f4b2ad56f010a4e9b93d547d63a15953d9dc2/actionpack/lib/action_dispatch/http/url.rb#L222
      # because `x-forwarded-host` returns cloud.gov url
      def raw_host_with_port
        ENV['HOST']
      end
    end
  end
end
