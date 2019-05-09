## Development

### Patterns

The Trusona gem is built with a few principles in mind:

1. Provide a simple, idomatic, rails-like public interface.
1. Reduce the scope of the internals exposed to the end-user of the gem.

#### Workers

Behind the public facing API are a variety of Workers that complete simple, single-focused tasks. For example, when creating a Trusonafication, the responsibility of creation is offloaded to the `Trusona::Workers::TrusonaficationCreator`. This pattern is used for nearly all aspects of the SDK internals.

#### Services

Communicating with the Trusona API is done via a set of `Trusona::Services` which are responsible for making HMAC'd requests to the Trusona API and verifying the HMAC'd responses from the Trusona API.

#### Resources

Resources are designed to be simple representations of entities which are represented by the Trusona API.

#### Mappers

Mappers help translate JSON representations of Trusona API entities to Resource objects.

### Rubocop

`Rubocop` is used to ensure adherence to an known style guide. It can be run
from the command line. Rubocop standards are currently _not_ enforced during
continuous integration builds.

`bundle exec rubocop lib`

### Testing

`bundle exec rake`

#### Integration Tests

Included in the `integrations` directory are a set of ever growing integration tests which rely on the Trusona config variables in your environment (try `.env`.)

##### One time setup

```bash
cp .env.example .env
```

Edit .env:

```txt
TRUSONA_TOKEN=<A Server RP token that can send trusonafications to your email>
TRUSONA_SECRET=<The Server RP secret>
TRUSONA_API_HOST=https://api.staging.trusona.net
INTEGRATION_TEST_EMAIL=<your UAT email>
```

The token needs to belong to relying party id `5dfc5568-fbd3-4c1c-80f6-d0cf3d9edc82` to work with the existing tests.

##### Running the tests

`bundle exec rspec integrations/`

#### Code Coverage

Code coverage is calculated used `SimpleCov` and can be found in the `coverage`
directory after running the tests

### Deployment

To deploy a new version of the gem to Artifactory, use `bump` to bump the
version by either `major`, `minor` or `patch` and then push the tags to
github. Travis CI will build and deploy any tagged commits.

1. Ensure a clean working directory
1. `bundle exec bump patch --tag`
1. `git push; and git push origin --tags`
