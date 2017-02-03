module ActionDispatch
  module Http
    module URL
      def raw_host_with_port
        ENV['HOST']
      end
    end
  end
end
