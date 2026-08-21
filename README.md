### About

Wrapper scripts for [Dokku](https://dokku.com/). Run once on your VPS, and a production ready
website will be running within 5 minutes, powered by Dokku.

#### Features

* WordPress
* Drupal
* Joomla
* Redmine (issue tracking)
* Dolibarr (ERP)
* SSL via Let's Encrypt, live and test certs
* Hopefully more soon ;-)

### Installing

```
curl -fsSL https://raw.githubusercontent.com/belal-i/dokku-scrubs/master/install.sh \
    | DOKKU_SCRUBS_VERSION=v0.7.0 bash
```

### Usage

The following examples should be self explanatory.

* Set up production ready WordPress site.
  ```
  dokku-scrubs --app wordpress --domain example.com --letsencrypt --email user@example.com
  ```

* Set up production ready Joomla site, use an older nonstandard version. Also, configure the
  `www` subdomain alongside the apex domain.
  ```
  dokku-scrubs --app joomla --appversion 5.4.2 --domain example.com --letsencrypt --email user@example.com --wwwsubdomain
  ```

* Set up Redmine (excellent open source issue tracker). Use a test certificate for SSL.
  ```
  dokku-scrubs --app redmine --domain example.com --letsencrypt --email user@example.com --testcert
  ```

#### Note about configuring database connection via web installer

Certain apps (for example Drupal), require to configure, among other things,
the database connection via their respective web installer.
This information can be retrieved via, for example, something like:

```
dokku mysql:info drupal-db
```
