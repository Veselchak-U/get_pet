# Get Pet
Flutter demo-project with backend.

Technologies: BLoC v.6 (Cubit), code generation, GraphQL, Hasura, Firebase

## Code generation
$ flutter packages pub run build_runner build --delete-conflicting-outputs

## Сonnecting GraphQL extention
1) Add [Apollo extention](https://marketplace.visualstudio.com/items?itemName=apollographql.vscode-apollo) in VSCode.

2) Add config file apollo.config.js with content:
`module.exports = {
  client: {
    includes: ['./lib/**/*.dart'],
    service: {
      name: 'app_name',
      url: 'graphgl_endpoint_url',
      // optional headers
      headers: {
        'x-hasura-admin-secret': 'secret_phrase',
        'x-hasura-role': 'admin',
      },
      // optional disable SSL validation check
      skipSSLValidation: true,
    },
  },
}`

3) Download schema.json:

`$ apollo schema:download`

## Build release apk for manual installation
$ flutter build apk --target-platform android-arm64

## Build an app bundle for Google Play
$ flutter clean
$ flutter build appbundle