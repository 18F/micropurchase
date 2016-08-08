require 'rails_helper'

describe SkillQuery do
  describe '#evaluated_auction_count' do
    it 'returns number of accepted and rejected auctions for that skill' do
      skill = create(:skill)
      other_skill = create(:skill)
      auction_1 = create(:auction, :accepted)
      auction_1.skills << [skill, other_skill]
      auction_2 = create(:auction, :rejected)
      auction_2.skills << skill
      auction_3 = create(:auction, :pending_acceptance)
      auction_3.skills << skill

      expect(SkillQuery.new(skill).evaluated_auction_count).to eq 2
    end
  end

  describe '#accepted_auction_count' do
    it 'returns number of accepted for that skill' do
      skill = create(:skill)
      other_skill = create(:skill)
      auction_1 = create(:auction, :accepted)
      auction_1.skills << [skill, other_skill]
      auction_2 = create(:auction, :rejected)
      auction_2.skills << skill
      auction_3 = create(:auction, :pending_acceptance)
      auction_3.skills << skill

      expect(SkillQuery.new(skill).accepted_auction_count).to eq 1
    end
  end
end
