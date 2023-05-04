# Setup puppet

```shell
bundle config set --local path 'vendor/bundle'
bundle install
bundle exec rake r10k:install
vagrant up puppet
```
