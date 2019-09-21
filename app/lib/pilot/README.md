# Client for PILOT
Client library to get data from https://pilot.khai.edu/

## Usage

### Init client
```ruby
login = 'login_in_pilot_system'
pass = 'pass_in_pilot_system'
pc = Pilot::Client.new(login, pass)
```

### Get all disciplines
```ruby
pc.get_disciplines
```

### Get groups for discipline
```ruby
discipline_id = 10680
pc.get_groups(discipline_id)
```

### Get lessons for discipline and group
```ruby
discipline_id = 10680
group_id = 21727
pc.get_lessons(discipline_id, group_id)
```

### Get students for discipline and group
```ruby
discipline_id = 10680
group_id = 21727
pc.get_students(discipline_id, group_id)
```

### Set mark and attendance for student
Coming soon...