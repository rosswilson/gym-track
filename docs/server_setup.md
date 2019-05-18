## Initial Package Upgrades

`apt-get update`

`apt-get dist-upgrade -y`

## Language Setup

Setup en-GB language support
`apt-get install -y language-pack-en`

Logout and log back in
`exit`

## Timezone Setup

Set timezone to London
`dpkg-reconfigure tzdata`

Logout and log back in
`exit`

## Enable Automatic Patching

Get a token from [https://auth.livepatch.canonical.com/?user_type=ubuntu-user](https://auth.livepatch.canonical.com/?user_type=ubuntu-user)

```
snap install canonical-livepatch
canonical-livepatch enable $TOKEN
```

## Firewall

```
ufw allow ssh
ufw allow http
ufw allow https
ufw enable
```

## Enable Monitoring

`curl -sSL https://agent.digitalocean.com/install.sh | sh`

## Update Root Password

`passwd`

Remember to save the new password in 1Password.

## Install Dokku
Following the [getting started guide](http://dokku.viewdocs.io/dokku/getting-started/installation/).

```
wget https://raw.githubusercontent.com/dokku/dokku/v0.16.4/bootstrap.sh
sudo DOKKU_TAG=v0.16.4 bash bootstrap.sh
```

Visit [calcium.rosswilson.co.uk](http://calcium.rosswilson.co.uk) and set the domain to `apps.rosswilson.co.uk`.

Tick the checkbox. This makes applications available at [myapp.apps.rosswilson.co.uk](myapp.apps.rosswilson.co.uk).

## Install Dokku Postgres Plugin
`dokku plugin:install https://github.com/dokku/dokku-postgres.git`

## Setup Application
```
dokku apps:create gym_track
dokku config:set gym_track SECRET_KEY_BASE=[generate a secret using mix phx.gen.secret]
dokku domains:add gym_track gym.rosswilson.co.uk
dokku postgres:create gym_track_db
dokku postgres:link gym_track_db gym_track
```

## Setup CircleCI SSH

```
cd /tmp
ssh-keygen
dokku ssh-keys:add circleci /tmp/id_rsa.pub
rm -rf /tmp/id_rsa /tmp/id_rsa.pub
```

## Configure Git Remote

`git remote add dokku dokku@calcium.rosswilson.co.uk:gym_track`

## Initial Deploy

`git push dokku master`