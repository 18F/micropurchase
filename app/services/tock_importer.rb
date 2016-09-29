class TockImporter
  TOCK_PROJECTS = "https://tock.18f.gov/api/projects.json".freeze

  def perform
    projects.each do |project|
      tock_project = ClientAccount.find_or_initialize_by(tock_id: project["id"])
      tock_project.name = project["name"]
      tock_project.billable = project["billable"]
      tock_project.active = project["active"]
      tock_project.save!
    end
  end

  private

  def projects
    JSON.parse(data)
  end

  def data
    request.body
  end

  def request
    RestClient.get(
      TOCK_PROJECTS,
      'Authorization' => "Token #{TockCredentials.api_token}"
    )
  end
end
