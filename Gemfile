source 'http://rubygems.org'

gem 'rails',	'2.3.4'
gem 'aws-s3'
gem 'mechanize', '1.0.0'
gem 'ruby-openid'
gem 'ruby-openid-apps-discovery'
gem 'rack-openid'

gem 'bundler'
gem 'delayed_job', '2.1.0.pre'


gem 'oauth'

gem 'heroku'
gem 'taps'

#gem 'vestal_versions', :git => 'git://github.com/adamcooper/vestal_versions'

gem 'rmagick'

group :plugins do
  gem 'authlogic'
  gem 'calendar_date_select' 
end



# gem 'smtp_tls'           # Used for sending mail to gmail
# gem 'actionmailer_gmail' # Used for sending mail to gmail

group :production do
  gem 'rcov' #This should not be necessary, but it's used by the Rakefile and it needs to be removed
  gem 'factory_girl' #This is necessary when we want to load factory seeds into a production database

  gem 'vestal_versions', '1.0.2' #, :git => 'git://github.com/laserlemon/vestal_versions'
end

group :development, :test do
  gem 'rake'
  gem 'pg'
  gem 'mongrel'
  gem 'ruby-debug-base' #'0.10.3'
  gem 'ruby-debug-ide' #'0.4.6'
  gem 'shoulda'
#  gem 'hanna'
  gem 'rcov'
  gem 'rdoc',    '2.4.3' #rdoc_rails required RDoc of 2.4.3 - http://stackoverflow.com/questions/2993435/rake-uninitialized-constant-rdocrdoc
  gem 'rspec-rails', '1.3.3'
  gem 'mocha'
  gem 'rspec',   '1.3.1'
  gem 'factory_girl'
  gem 'capybara'

#  gem 'autotest-rails' if RUBY_PLATFORM =~ /darwin/
#  gem "autotest-fsevent" if RUBY_PLATFORM =~ /darwin/
#  gem 'autotest-growl' if RUBY_PLATFORM =~ /darwin/

  gem 'test-unit', '1.2.3' #Downgrading so that autotest, rspec will work

  gem 'vestal_versions', '1.0.2' #, :git => 'git://github.com/laserlemon/vestal_versions'
end



#gem 'gchartrb'
