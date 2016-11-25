require_relative 'cloud_foundry'

module ServerEnv
  def self.instance_index
    CloudFoundry.instance_index || 0
  end

  def self.first_instance?
    instance_index.zero?
  end
end
