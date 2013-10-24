RAILS_ENV=production bundle exec rake assets:precompile
rake db:migrate RAILS_ENV=production
touch tmp/restart.txt
chown -R apache .
chgrp -R apache .
