# jbinto/rails4-sample-app-capistrano

This is an attempt to create a repeatable deployment script for the Ruby on Rails Tutorial (Michael Hartl) sample application to a VPS using Capistrano 3.1.0.

It flows directly from my other repo, [jbinto/ansible-ubuntu-rails-server](https://github.com/jbinto/ansible-ubuntu-rails-server), where I set up an Ubuntu deployment environment using Ansible and Vagrant.

This repo is forked from [mhartl/sample_app_4_0_upgrade](https://github.com/mhartl/sample_app_4_0_upgrade).

**Work in progress!** The instructions are still a little clunky, I'm updating them as I learn. It's evident I need to improve certain things. For instance, I'm not quite sure yet where Ansible should end and Capistrano should begin.


## Usage

First, set up the [jbinto/ansible-ubuntu-rails-server](https://github.com/jbinto/ansible-ubuntu-rails-server) Vagrant/Ansible box.

(Or, adapt the code to your environment. Specifically, `config/deploy.rb`, `config/deploy/*` and `lib/capistrano/*`.)

```
git clone https://github.com/jbinto/sample_app_4_0_upgrade.git
cd sample_app_4_0_upgrade
cap production deploy:setup_config
```

The database.example.yml is copied over, ssh in and add your username/host/password.

```
ssh deploy@10.33.33.33
cd ~/apps/APP_NAME/shared/config
cp database.example.yml database.yml
vi database.yml
```

Now, deploy the app:

```
cap production deploy
```

This will automatically run bundler and migrations.

You can do this manually:

```
cap production deploy:bundle
cap production deploy:migrate
```

** TODO: Restart nginx?


## Issues

When you first clone the repo, you need to do a few things:

* `cp db/database.yml.example db/database.yml` (since database.yml is under gitignore)
* `bundle exec rake db:test:prepare` (since there's a Capistrano task to run `rake spec` before deploying.)

## Original readme

This is the sample application for
[*Ruby on Rails Tutorial: Learn Web Development with Rails*](http://railstutorial.org/)
by [Michael Hartl](http://michaelhartl.com/). You can use this reference implementation to help track down errors if you end up having trouble with code in the tutorial. In particular, as a first debugging check I suggest getting the test suite to pass on your local machine:

    $ cd /tmp
    $ git clone git@github.com:railstutorial/sample_app_2nd_ed.git
    $ cd sample_app_2nd_ed
    $ bundle install
    $ bundle exec rake db:migrate
    $ bundle exec rake db:test:prepare
    $ bundle exec rspec spec/

If the tests don't pass, it means there may be something wrong with your system. If they do pass, then you can debug your code by comparing it with the reference implementation.


