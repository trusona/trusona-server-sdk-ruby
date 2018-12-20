# Trusona Ruby SDK

Easily interact with the Trusona REST API.

## Current Status

[![Build Status](https://travis-ci.com/lighthauz/trusona-server-sdk-ruby.svg?token=2f2CMAnop6pxz1LFFPky&branch=master)](https://travis-ci.com/lighthauz/trusona-server-sdk-ruby)
[![Maintainability](https://api.codeclimate.com/v1/badges/ec9f4f928125c278fa39/maintainability)](https://codeclimate.com/github/trusona/trusona-server-sdk-ruby/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/ec9f4f928125c278fa39/test_coverage)](https://codeclimate.com/github/trusona/trusona-server-sdk-ruby/test_coverage)

## Requirements
The Trusona SDK requires Ruby version 2.4.0 or higher.

## Examples

* [Installation](#installation)
* [Configuration](#configuration)
* [Device and User Bindings](#device-and-user-bindings)
* [Trusonafications](#trusonafications)
* [Devices](#devices)
* [Users](#users)

### Installation

The recommended way to add the Trusona gem to your project is to use `bundler`. To add
Trusona to your project, add the following line to your `Gemfile`.

`gem 'trusona'`

After adding the line to your `Gemfile`, running `bundle install` will install it.

The Trusona gem uses semantic versioning, so it is generally a good idea to lock in the
major version in your `Gemfile` before deploying to production.

### Configuration

Configuring the Trusona gem is easy. We recommend using environment variables and a tool like [dotenv](https://github.com/bkeepers/dotenv) for managing those environment variables.

```ruby
Trusona.config do |c|
  c.api_host       = ENV['TRUSONA_API_HOST']
  c.secret         = ENV['TRUSONA_SECRET']
  c.token          = ENV['TRUSONA_TOKEN']
end
```

The value of each required configuration parameter are provided by Trusona.

### Device and User Bindings

Before Trusonafications can be created for a user, the device registered with the Trusona Mobile SDK must be bound to a **unique-to-you** user identifier. The user identifier can be any value that helps you uniquely identify the user in your system.

Once this binding has been created, the user should be made to verify their account with your system. This may include:

* Email verification
* Logging in with existing credentials
* Answering security questions

Once the account has been verified, the Device and User Binding must be activated, which is your way of telling Trusona that this user is ready to accept Trusonafications.

#### Creating a Device and User Binding

The binding requires two values, the user identifier that helps you identify the user in your system and the device identifier as generated by the Trusona Mobile SDK on the user's device.

```ruby

  binding = Trusona::DeviceUserBinding.create(
    user: '83452353-4F7B-4CA2-BBCD-57ACE7279EA0',
    device: 'PBanKaajTmz_Cq1pDkrRzyeISBSBoGjExzp5r6-UjcI'
  )

```

#### Activating a Device and User Binding

```ruby
  # create the binding
  binding = Trusona::DeviceUserBinding.create(
    user: '83452353-4F7B-4CA2-BBCD-57ACE7279EA0',
    device: 'PBanKaajTmz_Cq1pDkrRzyeISBSBoGjExzp5r6-UjcI'
  )

  # go verify the user...

  # activate the binding
  Trusona::DeviceUserBinding.activate(id: binding.id)
```

### Creating Trusonafications

#### Creating an Essential Trusonafication

```ruby
  Trusona::EssentialTrusonafication.create(params: {
    action: 'login',
    resource: 'Acme Bank',
    device_identifier: 'PBanKaajTmz_Cq1pDkrRzyeISBSBoGjExzp5r6-UjcI'
   })
```

By default, Essential Trusonafications are built such that the user's presence is required and a prompt asking the user to "Accept" or "Reject" the Trusonafication is presented by the Trusona Mobile SDK. A user's presence is determined by their ability to interact with the device's OS Security, usually by using a biometric or entering the device passcode.

#### Creating an Essential Trusonafication, without user presence or a prompt

```ruby
  Trusona::EssentialTrusonafication.create(params: {
    action: 'login',
    resource: 'Acme Bank',
    device_identifier: 'PBanKaajTmz_Cq1pDkrRzyeISBSBoGjExzp5r6-UjcI',
    user_presence: false,
    prompt: false
   })
```

In the above example, the addition of `user_presence: false` and `prompt: false` will result in a Trusonafication that can be accepted solely with possession of the device.

#### Creating an Essential Trusonafication, with the user's email address
```ruby
  Trusona::EssentialTrusonafication.create(params: {
    action: 'login',
    resource: 'Acme Bank',
    email: 'user@domain.com'
   })
```
In some cases you may be able to send a Trusonafication to a user
by specifying their email address. This is the case if one of the following is true:
- You have verified ownership of a domain through the Trusona Developer's site
- You have an agreement with Trusona allowing you to send Trusonafications to any email address.
Creating a Trusonafication with an email address is similar to the other
use cases, except you use the `email` parameter rather than `user_identifier` or `device_identifier`.

#### An Executive level Trusonafication

```ruby
  Trusona::ExecutiveTrusonafication.create(params: {
    action: 'login',
    resource: 'Acme Bank',
    device_identifier: 'PBanKaajTmz_Cq1pDkrRzyeISBSBoGjExzp5r6-UjcI'
   })
```

#### Trusonafication Options

|       Name        |   Parameter Name    | Required |                                                            Description                                                            |
| :---------------- | :------------------ | :------: | :-------------------------------------------------------------------------------------------------------------------------------- |
| Action            | `action`            |    Y     | The action you want the user to take (e.g. 'login', 'verify')                                                                     |
| Resource          | `resource`          |    Y     | The resource to which the user is performing the action (e.g. 'website', 'account')                                               |
| Device Identifier | `device_identifier` |    N[^1] | The device identifier, retrieved from the mobile SDK, of the device to which this Trusonafication will be sent.                   |
| User Identifier   | `user_identifier`   |    N[^1] | The user identifier that has been registered with Trusona.                                                                        |
| Tru Code ID       | `trucode_id`        |    N[^1] | A Tru Code ID that has/will be paired by a device using the Trusona Mobile SDK that can be used to lookup the `device_identifier` |
| User Presence     | `user_presence`     |    N     | Should the user be required to demonstrate presence (e.g. via Biometric) when accepting this Trusonafication? Defaults to `true`. |
| Prompt            | `prompt`            |    N     | Should the user be prompted to Accept or Reject this Trusonafication? Defaults to `true`.                                         |
| Expiration        | `expires_at`        |    N     | The ISO-8601 UTC timestamp of the Trusonafication's expiration. Defaults to 90 seconds from creation.                             |

[^1]: You must provide at least one field that would allow Trusona to determine which user to authenticate. The identifier fields are `device_identifier`, `user_identifier`, and `trucode_id`.

#### Retrieving an existing Trusonafication

After creating a Trusonafication, you can fetch that Trusonafication using the `id`.

```ruby
  trusonafication = Trusona::EssentialTrusonafication.create(params: {
    action: 'login',
    resource: 'Acme Bank',
    device_identifier: 'PBanKaajTmz_Cq1pDkrRzyeISBSBoGjExzp5r6-UjcI'
   })

   # ...

   updated = Trusona::Trusonafication.find(trusonafication.id)
```

#### Automatically polling for Trusonafication status

Sometimes, you want to send a Trusonafication and wait for its completion by the user before proceeding. This can be accomplished by passing a block, and optional timeout, when creating a Trusonafication.

```ruby
  params = {
    action: 'login',
    resource: 'Acme Bank',
    device_identifier: 'PBanKaajTmz_Cq1pDkrRzyeISBSBoGjExzp5r6-UjcI'
  }

  Trusona::EssentialTrusonafication.create(params: params) do | trusonafication |
    # Block will be executed when the user has acted on the Trusonafication
    # OR when the Trusonafication has expired.

    if trusonafication.accepted?
      # start the parade
    end
  end
```

### Devices

#### Finding a Device

If you want to check whether or not a device has been activated, or when it was activated, you can look it up in Trusona using the device's identifier.

```ruby
  device = Trusona::Device.find(id: 'r1ByVyVKJ7TRgU0RPX0-THMTD_CO3VrCSNqLpJFmhms')
  if device.active
    # dance
  end
```

### Users

#### Creating a User

Users are created implicitly the first time you bind a user to a device.

#### Deactivating a User

You may wish to disable a user from having the ability to authenticate from any of the devices they have registered with. To deactivate a user:

```ruby
  Trusona::User.deactivate(user_identifier: '83452353-4F7B-4CA2-BBCD-57ACE7279EA0')
```

The deactivated user can be reactivated at a later date by binding them to a new device in Trusona.