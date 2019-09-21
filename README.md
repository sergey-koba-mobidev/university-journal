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
- k8s

## Getting Started

### Prerequirities
- install [Docker](https://docs.docker.com/install/)
- install [Docker Compose](https://docs.docker.com/compose/install/)

### Install
- `cp .env.example .env`
- modify variables in `.env` file. For example `TELEGRAM_BOT_API_TOKEN`
- `docker-compose build` - build docker images
- `docker-compose up -d db` - spin up db container
- `docker-compose run --rm web bundle install --with test development` - intasll gems for ruby
- `docker-compose run --rm web rake db:create` - create database
- `docker-compose run --rm web rake db:migrate` - migrate database
- `docker-compose run --rm web rake db:seed` - seed database with test data
- `docker-compose run --rm modules_front npm install` - install npm for modules
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
- `docker-compose run --rm web bundle exec rake db:migrate RAILS_ENV=test`
- `docker-compose run --rm web bundle exec rspec`

## Doc
- build doc `docker-compose run web bundle exec rake docs:generate`
- open file `./doc/api/idnex.html`

# Deployment
- create `chart/templates/postgres_secret.yaml` with the following content, replace `BASE64_...` values
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: "{{ include "chart.name" . }}-postgres-secret"
  labels:
    app.kubernetes.io/name: "{{ include "chart.name" . }}-postgres-secret"
    helm.sh/chart: {{ include "chart.name" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
    app.kubernetes.io/managed-by: {{ .Release.Service }}
type: Opaque
data:
  POSTGRES_USER: "BASE64_USER"
  POSTGRES_PASSWORD: "BASE64_PASS"
  POSTGRES_DB: "BASE64_DB"
```
- create `chart/templates/web_secret.yaml`, apply base64 to secrets values
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: "{{ include "chart.name" . }}-web-secret"
  labels:
    app.kubernetes.io/name: "{{ include "chart.name" . }}-web-secret"
    helm.sh/chart: {{ include "chart.name" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
    app.kubernetes.io/managed-by: {{ .Release.Service }}
type: Opaque
data:
  SMTP_PASSWORD: "..."
  S3_ACCESS_KEY_ID: "..."
  S3_SECRET_ACCESS_KEY: "..."
```
- run `./bin/deploy.sh`

# Roadmap
- Backup data
- Disciplines can change teachers in other semester
- expire for cache
- button to set no attends with 1 click
- finish vue modules
