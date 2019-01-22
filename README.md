# University-journal
A Ruby on Rails based university classes manager.

## Main features:
- Users with 3 roles: admin, teacher, student
- Managing Semesters
- Managing Disciplines
- Managing Groups of students
- Managing Labs, Lectures, Modules, Exams, Homework
- Autocalculating the student rank
- Uploading Homework and adding corrections.

## Additional features
- uses cache for stressful queries
- notifies about homework via email
- ansible + capistrano deployment

## Getting Started

### Prerequirities
- install [Docker](https://docs.docker.com/install/)
- install [Docker Compose](https://docs.docker.com/compose/install/)

### Install
- `cp .env.example .env`
- `docker-compose build` - build docker images
- `docker-compose up -d db` - spin up db container
- `docker-compose run web bundle install --with test development` - intasll gems for ruby
- `docker-compose run web rake db:create` - create database
- `docker-compose run web rake db:migrate` - migrate database
- `docker-compose run web rake db:seed` - seed database with test data
- `docker-compose run modules_front npm install` - install npm for modules
- `docker-compose up -d`
- go to [http://localhost](http://localhost) use `admin@journal.com/12345678` as login and password for Admin
- go to [http://localhost](http://localhost) use `student@journal.com/12345678` as login and password for Student
- go to [http://localhost/modules](http://localhost/modules) use `student@journal.com/12345678` to login as Student and pass modules or `admin@journal.com/12345678` to login as teacher and edit modules.

### Start app
- `docker-compose up -d`

### Stop app
- `docker-compose stop`

### Remove app
- `docker-compose down`

## Tests
- `docker-compose run web bundle exec rspec`

## Doc
- build doc `docker-compose run web bundle exec rake docs:generate`
- open file `./doc/api/idnex.html`

# Deployment
- run ansible as `cd ansible/deployment` & `ansible-playbook -i inventories/production appservers.yml`
- run capistrano as `cap production deploy`

# Roadmap
- Backup data
- Disciplines can change teachers in other semester
- expire for cache
- button to set no attends with 1 click
- kubernetes
