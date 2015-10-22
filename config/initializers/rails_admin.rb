RailsAdmin.config do |config|

  config.authorize_with do
    if !(current_user && Admins.verify?(current_user.github_id))
      render text: "Not authorized"
    end
  end

  config.navigation_static_links = {
    'Log out' => '/logout'
  }

  config.audit_with :paper_trail, 'User', 'PaperTrail::Version'

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
