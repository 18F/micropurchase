# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

FactoryGirl.create(
  :current_auction,
  issue_url: 'https://github.com/18F/mpt3500/issues/10',
  title: 'Build a Placeholder for MPT 3500',
  description: 'This auction is a placeholder for MPT 3500. The MPT 3500 team needs to build the following ...',
  github_repo: 'https://github.com/18F/mpt3500')
