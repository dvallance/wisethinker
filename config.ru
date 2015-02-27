require 'wisethinker'
require 'wisethinker/web_server'

#flush output immediately. Docker containers running thin will benifit from
#this.
$stdout.sync = true

run Wisethinker::WebServer
