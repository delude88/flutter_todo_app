# flutter_todo_app

Yet another flutter todo app, but using a more complex and related model

## Model

### User

-id

- can have 0-n todos

### Todo

- id
- can have 0-n tasks
- is assigned to an user

### Task

- id
- text field
- is assigned to an todo

## References

Nice option about architecture: https://github.com/felangel/bloc/issues/2436#issuecomment-830993494
Short summery:
``
Regarding the bloc layer, I would recommend a single bloc per feature (or UI view/widget). Each
repository can handle exposing a Stream of models so that each of the blocs can react to changes in
realtime without needing to depend on each other. In my opinion, it's best to have a single data
provider per data source, a single repository per domain, and a single bloc per feature. I would
also recommend having blocs only depend on one or more repositories and repositories depend on one
or more data providers and to avoid inter-bloc, inter-repository, or inter-data provider
dependencies.
``

https://medium.com/flutter-community/blocs-with-reactive-repository-5fd440d3b1dc
