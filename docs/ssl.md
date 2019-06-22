## Download Lego
We're using Lego to manage issuing of [LetsEncrypt](https://letsencrypt.org) certificates.

* Downloaded the latest `linux_amd64` binary release from [xenolf/lego](https://github.com/xenolf/lego/releases).
* Moved the binary to `/usr/local/bin/lego` on the server.
* Ensure it can be executed: `chmod +x /usr/local/bin/lego`
* Check that it is available by running `lego --version`

## Configure AWS

Create an AWS IAM Policy called `route-53-modify-ross-wilson-zone`, with the following JSON
(replacing `YOUR_ZONE_ID` with your domain zone ID):

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZonesByName",
                "route53:ListHostedZones",
                "route53:GetChange"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "route53:ListResourceRecordSets",
                "route53:ChangeResourceRecordSets"
            ],
            "Resource": [
                "arn:aws:route53:::hostedzone/YOUR_ZONE_ID"
            ]
        }
    ]
}
```

Create an AWS IAM User for the server, e.g. `calcium-server` and assign it the new policy.

Generate a secret key pair, and create a file on the server called `/root/.aws/credentials` with the following contents:

```
[default]
aws_access_key_id=ACCESS_KEY_ID_HERE
aws_secret_access_key=SECRET_ACCESS_KEY_HERE
```

## First Run

As the `root` user, move to the home directory: `cd ~`

Run the following command to issue a certificate for the specified domains:

```
AWS_REGION=eu-west-1 /usr/local/bin/lego --email="me@rosswilson.co.uk" --domains="gym.rosswilson.co.uk" --dns="route53" --accept-tos run
```

Confirm that certificates exist:

`ls -la ~/.lego/certificates`

## Configure Dokku

To enable HTTPS with Dokku, it expects the certs to be in a tar bundle:

`cd ~/.lego/certificates/; tar cvf cert-key.tar gym.rosswilson.co.uk.crt gym.rosswilson.co.uk.key`

Add them to Dokku for the specified app:

`dokku certs:add gym_track < cert-key.tar`

## Patch nginx

Update `/etc/nginx/conf.d/dokku.conf` to update the SSL ciphers, since `lego` generates ECDSA certs:

```
ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA;
```

## Testing

HTTPS should now be working:

[gym.rosswilson.co.uk](https://gym.rosswilson.co.uk)

Delete the tar bundle:

`shred cert-key.tar`

## Certificate Refreshing

Certificates from LetsEncrypt are only valid for 90 days, so we need to periodically refresh them. We can setup a cron task to do that automatically.

Create an executable file at `/etc/cron.daily/lego` with the following contents:

```sh
#!/bin/sh

test -x /usr/local/bin/lego || exit 0

cd /root

AWS_REGION=eu-west-1 /usr/local/bin/lego --email="me@rosswilson.co.uk" --domains="gym.rosswilson.co.uk" --dns="route53" --accept-tos renew --days 30

cp /root/.lego/certificates/gym.rosswilson.co.uk.crt /home/dokku/gym_track/tls/server.crt
cp /root/.lego/certificates/gym.rosswilson.co.uk.key /home/dokku/gym_track/tls/server.key

service nginx reload
```

`chmod +x /etc/cron.daily/lego`