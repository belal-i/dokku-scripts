### About

Wrapper scripts for [Dokku](https://dokku.com/). Run once on your VPS, and a production ready
website will be running within 5 minutes, powered by Dokku.

#### Features

* WordPress
* Joomla
* Redmine
* SSL via Let's Encrypt, live and test certs
* Hopefully more soon ;-)

### Installing

```
curl -fsSL https://raw.githubusercontent.com/belal-i/dokku-scrubs/master/install.sh | bash
```

### Usage

The following examples should be self explanatory.

* Set up production ready WordPress site.
  ```
  dokku-scrubs --app wordpress --domain example.com --letsencrypt --email user@example.com
  ```

* Set up production ready Joomla site, use an older nonstandard version.
  ```
  dokku-scrubs --app joomla --appversion 5.4.2 --domain example.com --letsencrypt --email user@example.com
  ```

* Set up Redmine (excellent open source issue tracker). Use a test certificate for SSL.
  ```
  dokku-scrubs --app redmine --domain example.com --letsencrypt --email user@example.com --testcert
  ```

### Known issues

It's not idempotent. It's only meant to be run once on your server, to conveniently spin everything up.
If you need to adjust or extend your environment, [Dokku](https://dokku.com/) has excellent
support for all of that.
