namespace :sam do
  task check: :environment do
    User.not_in_sam.each do |user|
      id = "#{user.name}/#{user.duns_number}: "
      begin
        sam_status = user.save_sam_status
        if sam_status == true
          id += 'DUNS *is* in SAM.gov'
        else
          id += 'DUNS *not* found in SAM.gov'
        end
      rescue Samwise::Error::InvalidFormat => e
        id += e.message
      end
      puts id unless Rails.env.test?
    end
  end
end
