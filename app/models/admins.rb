class Admins
  def verify?(uid)
    return false if uid.nil?
    github_ids.include?(uid.to_s)
  end

  def github_ids
    self.class.github_ids.map(&:to_s)
  end

  def self.github_ids
    @github_ids ||= YAML.load(File.read(File.expand_path("../../../config/admins.yml", __FILE__)))['github_ids']
  end

  def self.verify?(uid)
    new.verify?(uid)
  end
end
