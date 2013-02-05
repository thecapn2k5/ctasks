#!/usr/bin/python

import os

files = [
   'app/assets/javascripts/application.js',
   'app/assets/stylesheets/custom.css.scss',
   'app/controllers/application_controller.rb',
   'app/controllers/sessions_controller.rb',
   'app/controllers/static_pages_controller.rb',
   'app/controllers/users_controller.rb',
   'app/helpers/application_helper.rb',
   'app/helpers/sessions_helper.rb',
   'app/helpers/users_helper.rb',
   'app/models/user.rb',
   'app/views/layouts/_footer.html.erb',
   'app/views/layouts/_header.html.erb',
   'app/views/layouts/application.html.erb',
   'app/views/sessions/new.html.erb',
   'app/views/shared/_error_messages.html.erb',
   'app/views/static_pages/about.html.erb',
   'app/views/static_pages/contact.html.erb',
   'app/views/static_pages/help.html.erb',
   'app/views/static_pages/home.html.erb',
   'app/views/users/_user.html.erb',
   'app/views/users/edit.html.erb',
   'app/views/users/index.html.erb',
   'app/views/users/new.html.erb',
   'app/views/users/show.html.erb',
   'config/environments/production.rb',
   'config/environments/test.rb',
   'config/routes.rb',
   'lib/tasks/sample_data.rake',
   'spec/factories.rb',
   'spec/models/user_spec.rb',
   'spec/requests/authentication_pages_spec.rb',
   'spec/requests/static_pages_spec.rb',
   'spec/requests/user_pages_spec.rb',
   'spec/support/utilities.rb'
]

for fullfile in files:
   fileparts = fullfile.split('/')
   dir = '/'.join(fileparts[:-1])
   file = fileparts[-1]
   #print "cp ../temp_for_ctasks/%s %s/%s" % (fullfile, dir, file)
   os.popen2("cp ../temp_for_ctasks/%s %s/%s" % (fullfile, dir, file))
