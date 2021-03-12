# Froggo

This is a Rails application, initially generated using [Potassium](https://github.com/platanus/potassium) by Platanus.

# This is Fake!

## Local installation

Assuming you've just cloned the repo, run this script to setup the project in your
machine:

    $ ./bin/setup

It assumes you have a machine equipped with Ruby, Node.js, Docker and make.

The script will do the following among other things:

- Install the dependecies
- Create a docker container for your database
- Prepare your database
- Adds heroku remotes

After the app setup is done you can run it with [Heroku Local]

    $ heroku local

[heroku local]: https://devcenter.heroku.com/articles/heroku-local

## Continuous Integrations

The project is setup to run tests
in [CircleCI](https://circleci.com/gh/platanus/froggo/tree/master)

You can also run the test locally simulating the production environment using docker.
Just make sure you have docker installed and run:

    bin/cibuild

## Style Guides

Style guides are enforced through a CircleCI [job](.circleci/config.yml) with [reviewdog](https://github.com/reviewdog/reviewdog) as a reporter, using per-project dependencies and style configurations.
Please note that this reviewdog implementation requires a GitHub user token to comment on pull requests. A token can be generated [here](https://github.com/settings/tokens), and it should have at least the `repo` option checked.
The included `config.yml` assumes your CircleCI organization has a context named `org-global` with the required token under the environment variable `REVIEWDOG_GITHUB_API_TOKEN`.

The project comes bundled with configuration files available in this repository.

Linting dependencies like `rubocop` or `rubocop-rspec` must be locked in your `Gemfile`. Similarly, packages like `eslint` or `eslint-plugin-vue` must be locked in your `package.json`.

You can add or modify rules by editing the [`.rubocop.yml`](.rubocop.yml), [`.eslintrc.json`](.eslintrc.json) or [`.stylelintrc.json`](.stylelintrc.json) files.

You can (and should) use linter integrations for your text editor of choice, using the project's configuration.

## Sending Emails

The emails can be send through the gem `aws-sdk-rails` using the `aws_sdk` delivery method.
All the `action_mailer` configuration can be found at `config/mailer.rb`, which is loaded only on production environments.

All emails should be sent using background jobs, by default we install `sidekiq` for that purpuse.

#### Testing in staging

If you add the `EMAIL_RECIPIENTS=` environmental variable, the emails will be intercepted and redirected to the email in the variable.

## Internal dependencies

### Authorization

For defining which parts of the system each user has access to, we have chosen to include the [Pundit](https://github.com/elabs/pundit) gem, by [Elabs](http://elabs.se/).

### Authentication

We are using the great [Devise](https://github.com/plataformatec/devise) library by [PlataformaTec](http://plataformatec.com.br/)

### File Storage

For managing uploads, this project uses [Active Storage](https://github.com/rails/rails/tree/master/activestorage).

### Rails pattern enforcing types

This projects uses [Power-Types](https://github.com/platanus/power-types) to generate Services, Commands, Utils and Values.

### Presentation Layer

This project uses [Draper](https://github.com/drapergem/draper) to add an object-oriented layer of presentation logic

### Error Reporting

To report our errors we use [Sentry](https://github.com/getsentry/raven-ruby)

### Administration

This project uses [Active Admin](https://github.com/activeadmin/activeadmin) which is a Ruby on Rails framework for creating elegant backends for website administration.

This project supports Vue inside ActiveAdmin

- The main package is located in `app/javascript/packs/admin_application.js`, here you will declare the components you want to include in your ActiveAdmin views as you would in a normal Vue App.
- Additionally, to be able to use Vue components as [Arbre](https://github.com/activeadmin/arbre) Nodes the component names are also declared in `config/initializers/active_admin.rb`
- The generator includes an example component called `admin_component`, you can use this component inside any ActiveAdmin view by just writing `admin_component` as you would with any `html` tag.
  - For example:
    ```
    admin_component(class:"myCustomClass",id:"myCustomId") do
      admin_component(id:"otherCustomId")
    end
    ```
  - (Keep in mind that the example works with ruby blocks because `AdminComponent` has a `<slot>` tag defined, therefore children can be added to the component)
- The integration supports passing props to the components and converts them to their corresponing javascript objects.
  - For example, the following works
  ```
  admin_component(testList:[1,2,3,4],testObject:{"name":"Vue component"})
  ```
  - You can also use **any** vue bindings such as `v-for` , `:key` etc.

### Scheduled Tasks

To schedule recurring work at particular times or dates, this project uses [Sidekiq Scheduler](https://github.com/moove-it/sidekiq-scheduler)

### Queue System

For managing tasks in the background, this project uses [Sidekiq](https://github.com/mperham/sidekiq)

## Seeds

To populate your database with initial data you can add, inside the `/db/seeds.rb` file, the code to generate **only the necessary data** to run the application.
If you need to generate data with **development purposes**, you can customize the `lib/fake_data_loader.rb` module and then to run the `rake load_fake_data` task from your terminal.

## Development

For hot-reloading and fast webpacker compilation you need to run webpack's dev server along with the rails server:

    $ ./bin/webpack-dev-server

Running the dev server will also solve problems with the cache not refreshing between changes and provide better error messages if something fails to compile.

For even faster in-place component refreshing (with no page reloads), you can enable Hot Module Reloading in `config/webpacker.yml`

    development:
      dev_server:
        hmr: true
