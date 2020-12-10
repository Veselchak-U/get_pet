# Get Pet
Flutter demo-project with backend.

Technologies: BLoC v.6 (Cubit), code generation, GraphQL, Hasura, Firebase

## Code generation
$ flutter packages pub run build_runner build --delete-conflicting-outputs

## Build release apk for manual installation
$ flutter build apk --target-platform android-arm64

## Build an app bundle for Google Play
$ flutter build appbundle