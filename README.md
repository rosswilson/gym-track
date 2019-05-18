# GymTrack

[![CircleCI](https://circleci.com/gh/rosswilson/gym-track.svg?style=svg&circle-token=40a4881073008c2fab672f2e39b4c85ecbcde074)](https://circleci.com/gh/rosswilson/gym-track)

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Production

This is just a hobby project, so I'm using a single Digital Ocean droppet, and
[Dokku](http://dokku.viewdocs.io) to host this application in production:

[gym.rosswilson.co.uk](http://gym.rosswilson.co.uk/)

CircleCI builds every branch, and `master` branch updates automatically get deployed.
Any pending database migrations are run automatically after every deployment.