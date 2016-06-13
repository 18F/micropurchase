class TockImporter
  TOCK_PROJECTS = "https://tock-app.18f.gov/api/projects.json".freeze

  def perform
    projects.each do |project|
      tock_project = ClientAccount.find_or_initialize_by(tock_id: project["id"])
      tock_project.name = project["name"]
      tock_project.billable = project["billable"]
      tock_project.save!
    end
  end

  private

  def projects
    @_projects ||= json["results"]
  end

  def json
    JSON.parse(data)
  end

  def data
    Net::HTTP.get(URI(TOCK_PROJECTS))
  end
end
