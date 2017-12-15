# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# Write the code in a way that can be executed multiple times without duplicating the information.
#
# For example:
#
# Country.create(name: "Chile") # BAD
# Country.find_or_create_by(name: "Chile") # GOOD
#

require 'json'

repo_hash = JSON.parse(File.read('db/repositories.json'))

Repository.find_or_create_by( 
    gh_id: repo_hash["id"],
    name: repo_hash["name"],
    full_name: repo_hash["full_name"],
    tracked: false,
    url: repo_hash["url"],
    html_url: repo_hash["html_url"],
    organization: Organization.last
)
