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

# Deployment
- run ansible as `cd ansible/deployment` & `ansible-playbook -i inventories/production appservers.yml`
- run capistrano as `cap production deploy`

# TODO:
- Backup data
- Disciplines can change teachers in other semester
- after visit creation the tab is dropped
- edit dates for visits
- add RAILS_ENV export to .bashrc