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
- `docker-compose build`
- `docker-compose up -d db`
- `docker-compose run web bundle install --with test development`
- `docker-compose run web rake db:create`
- `docker-compose run web rake db:migrate`
- `docker-compose run web rake db:create_admin`
- `docker-compose up -d`
- go to [http://localhost:3000](http://localhost:3000) use `admin@journal.com/12345678` as login and password

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
- add RAILS_ENV export to .bashrc
- button to set no attends with 1 click
- docker
