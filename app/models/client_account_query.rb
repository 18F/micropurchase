class ClientAccountQuery
  attr_reader :relation

  def initialize(relation = ClientAccount.all)
    @relation = relation
  end

  def active
    relation.where(active: true)
  end
end
