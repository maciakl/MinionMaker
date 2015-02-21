Minion Academy
===

The source code for [minion.academy](http://minion.academy) web app.

Development
---

Unit tests are in the `tests/` directory. To run all the tests for all the files do:

    rake test

I'm using MiniTest with the assertion syntax because reasons.

To run a local WebRick server run

    rake run

Note, the rake command binds the ip to `0.0.0.0` so that the WebRick instance can be
accessed from another computer on the same network. This is something that is useful
to me but YMMV.

Deploying Updates
---

App is running on heroku so just do:

    git push heroku master

To get logs:

    heroku logs

Dependencies
---

- [Sinatra](http://sinatrarb.com)
- [HAML](http://haml.info)
- [Pickup](https://rubygems.org/gems/pickup)
