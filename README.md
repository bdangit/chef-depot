Habitat Depot
=============

This cookbook will set up a private [Habitat](http://habitat.sh) Depot, running all the required services on one machine.

While this is tested and may work for other users, private depots are *not yet supported* by Chef Software, Inc. nor the Habitat project. Use at your own risk, and be aware that there is no planned migration strategy.

## Requirements

- Chef 12.11 or higher (for [habitat cookbook](https://supermarket.chef.io/cookbooks/habitat))

## Platform Support

- Ubuntu 16.04

## Setup

Place a dependency on the depot cookbook in your cookbook's metadata.rb.

```ruby
depends 'depot', '~> 0.2.0'
```

Then, in a recipe:

```ruby
include_recipe 'depot'
```

A service will be created as `hab-depot`.

## Attributes

There are several attributes used to render the configuration files used for the api and sessionsrv services. They live under `node['depot']['oauth']` and `node['depot']['user_toml']`.

|*name*|*default*|*description*|
|------|---------|-------------|
|`node['depot']['oauth']['client_id']`|`nil`| Github Client ID for OAuth |
|`node['depot']['oauth']['client_secret']`|`nil`| Github Client Secret for OAuth |
|`node['depot']['user_toml']`|See `./attributes/default.rb`| Specify each key in the hash rendered in the TOML file with its value |
|`node['depot']['user_toml']['app_url']`|`'http://FQDN/v1'`| FQDN defaults to `node['fqdn']`, falling back to `node.name` |

If the `client_id` and `client_secret` are not set, users will not be able to sign in, create origins, or upload packages to the Depot. Create an OAuth application on Github first, and then use the values for these attributes.

## Local Test

Run a local Depot for testing with test kitchen.

    $ kitchen converge

A VM will start up on 192.168.96.31, and will be accessible at http://192.168.96.31 from the host machine.

Once this is provisioned, it can be used for local testing. In order to upload packages, a Github OAuth application and personal access token must be created and the kitchen VM re-configured.

1. Create a new OAuth application [on Github](https://github.com/settings/applications/new). Name it `kitchen-habitat-depot` or similar. The homepage URL should be `http://192.168.96.31`. The Authorization Callback URL must be `http://192.168.96.31/#/sign-in`. Save the client ID and client secret to a shell script file that looks like this:
```
export GITHUB_CLIENT_ID=1edd05b4912af4eed6e16b9a
export GITHUB_CLIENT_SECRET=4fdedc08a0a0d9c035a321edd05b4912af4eed6e16b9a
```
Source this file in the shell and rerun `kitchen converge`.
```
$ . ~/.github/kitchen-habitat-depot-oauth
$ kitchen converge
```
2. Create a personal access token [on Github](https://github.com/settings/tokens/new). Name it `kitchen-habitat-depot` or similar. Give it permission to `user` and `user:email`. Save the token to a file, for example `~/.github/kitchen-habitat-depot`
3. Open the local Depot at [http://192.168.96.31](http://192.168.96.31).
4. Sign-in using Github on the [sign-in page](http://192.168.96.31/#/sign-in).
5. Create a new origin in the UI.
6. Create a new origin key on the local system and upload it to the Depot.
```
$ hab origin key generate kitchen-tester
$ hab origin key upload --url http://192.168.96.31/v1/depot kitchen-tester -z $(cat ~/.github/kitchen-habitat-depot)
```
7. Create packages using that origin, and then upload them to the depot!
```
$ hab pkg upload --url http://192.168.96.31/v1/depot somepackage.hart -z $(cat ~/.github/kitchen-habitat-depot)
```
