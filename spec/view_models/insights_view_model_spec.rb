require 'rails_helper'

describe InsightsViewModel do
  describe '#sorted_skills_count' do
    it 'returns skill counts ordered by evaluated count' do
      skill_1 = create(:skill)
      zero_double = double(evaluated_auction_count: 0, accepted_auction_count: 0)
      allow(SkillQuery).to receive(:new).with(skill_1).and_return(zero_double)
      skill_3 = create(:skill)
      three_double = double(evaluated_auction_count: 3, accepted_auction_count: 0)
      allow(SkillQuery).to receive(:new).with(skill_3).and_return(three_double)
      skill_2 = create(:skill)
      two_double = double(evaluated_auction_count: 2, accepted_auction_count: 0)
      allow(SkillQuery).to receive(:new).with(skill_2).and_return(two_double)


      skills_count = InsightsViewModel.new.sorted_skills_count

      expect(skills_count.map(&:name)).to eq([
        skill_3.name,
        skill_2.name,
        skill_1.name
      ])
    end
  end
end
