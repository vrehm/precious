# require "rubygems"
# require "bundler"
# require "gollum"
# Bundler.require(:default)

# require "gollum/frontend/app"

# use Rack::Auth::Basic, "Restricted Area" do |username, password|
#   [username, password] == ['admin', 'admin']
# end

# Precious::App.set(:gollum_path, '/path/to/gollum_repo')
# Precious::App.set(:wiki_options, {})
# run Precious::App

require 'rubygems'
require 'gollum/app'

auth_config_path = "secret.yml"
if File.exists?(auth_config_path)
  AUTH_CONFIG = YAML.load_file(auth_config_path)
else
  AUTH_CONFIG = {user: ENV['user'], pass: ENV['pass']}
end

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  [username, password] == [ENV['user'], ENV['pass']]
end

gollum_path = '.'

# This is the key to make Gollum work on Heroku
unless File.exists? '.git'
  repo = Grit::Repo.init(gollum_path)
  repo.add('.')
  repo.commit_all('Create gollum wiki')
end

Precious::App.set(:default_markup, :markdown)
Precious::App.set(:wiki_options, { universal_toc: false, live_preview: true })
Precious::App.set(:gollum_path, gollum_path)
run Precious::App
