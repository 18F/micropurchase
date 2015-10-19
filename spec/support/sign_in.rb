def session_authentication
  {'rack.session' => {uid: current_user_uid}}
end

def current_user_uid
  '12345'
end
