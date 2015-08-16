server '46.101.253.11', roles: %w{web app db}

set :ssh_options, {
    user: 'univeruser',
    forward_agent: false,
    keepalive: true,
    port: 22
}