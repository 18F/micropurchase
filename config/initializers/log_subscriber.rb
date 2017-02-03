module ActionController
  class LogSubscriber
    def redirect_to(event)
      info { "Redirected to #{event.payload[:location]}" }
      info { "Caller: #{caller.join("\n")}" }
    end
  end
end


<<-EOS

BROWSER   -->>>>> cloud.gov --------> host

Host: right one
                 Host: right one
                 X-Forwarded-For: internal one

                                         def host_with_port
                                         end


EOS
