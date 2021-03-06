Migrating to Go Modules
=======================

A developer guide for migrating an existing Go project from govendor to modules and getting it building in CI.

### Prerequisites
- Go Modules was introduced in Go `1.11`? so you will need to ensure you are running Go `1.11` or later.
- It's worth reading the [Golang Modules guide](https://blog.golang.org/using-go-modules) it covers the
basics of modules and is a good reference for getting started.

### Creating a module

A Go module project is required to live outside of your `$GOPATH`. If you haven't already
- Create a new _"go projects"_ directory outside of your `$GOPATH` . For me this is: `/Users/dave/go-projects`
- Git clone the app you are migrating into this directory.
- Create and switch to a feature branch for the migration.

#### Vendor
Go modules does support migrating from vendor but I ran into issues whilst trying this. For now, I would recommend
 starting fresh and deleting the `/vendor` dir from your project. This will give you a clean slate and bring in the
  latest version of each dependency. If your project relies on a specific version you can fix this later.

To create a module run: `go mod init <MODULE_NAME>` in root dir of your project. `<MODULE_NAME>` is used by external
 packages importing your code. For existing apps, we need to maintain backwards compatibility so module name must be
  `github.com/ONSdigital/<REPO_NAME>`.

Example:
```bash
go mod init github.com/ONSdigital/dp-recipe-api
```

This will create empty `go.mod` && `go.sum` files. If you need specific version of a dependency you can edit this file
as required. See the [Golang Modules guide](https://blog.golang.org/using-go-modules) for details on how versioning is
handled in Go Modules.

If you run `go test` modules will resolve any missing dependencies before running any unit tests. You should see output
similar too:
```
    $ go test ./...
    go: finding <SOME_DEPENDENCY> vX.X.X
    go: downloading <SOME_DEPENDENCY> vX.X.X
    go: extracting <SOME_DEPENDENCY> vX.X.X
    ...
```

Assuming all is well:
- The dependencies should resolve successfully
- The unit tests should pass
- The `go.mod` && `go.sum` files should be updated to include the dependencies of your project. It should look something
 like:

    ```
    module github.com/ONSdigital/dp-recipe-api

    go 1.12

    require (
        ...
        github.com/ONSdigital/dp-api-clients-go v0.0.0-20190920133223-0b75bbb235dd
        github.com/ONSdigital/dp-mocking v0.0.0-20190905163309-fee2702ad1b9 // indirect
        github.com/ONSdigital/dp-rchttp v0.0.0-20190919143000-bb5699e6fd59
        ...
    )
    ```

At this point its recommend you run your app and verifying everything still works as expected. If applicable you
 should also run any integration tests to boost your confidence that the migration has not adversely affected any
  functionality. If everything is working as expected *Congratulations* you have successfully migrated your app to
   Go modules.

### Modules in Goland IDE
If you use the Goland IDE you need to update it's settings to enable modules integration:
 - `Goland` >> `Preferences`

  ![1](../img/goland_mod_1.png)
 - `Go` >> `Go Modules (vgo)`
    - Check `Enable Go Modules (vgo) integration`
    - `Vgo Executable:` - `Project SDK`
    - `Proxy` - blank.

  ![2](../img/goland_mod_2.png)

This should fix any import and/or compliation errors.

### Modules in VSCode
If you use VSCode and you have the Go extension installed, it will prompt you to install the go language server (`gopls`) the first time it opens a project with a `go.mod` outside of your GOPATH. There is more detail around this in [the extension's README](https://github.com/microsoft/vscode-go/blob/master/README.md#go-language-server).

### Building in CI
The previous steps cover converting a project and getting it building/running locally. The following steps detail how
 to get the project building successfully in the CI pipeline.

- Update `Makefile` removing any references to the vendor directory. For example:
    ```yaml
    # go test -cover $(shell go list ./... | grep -v /vendor/)
    go test -cover ./...
    ```
- Update `/ci/build.yml` and `ci/unit.yml` with the following changes:
    - Ensure the the go version is 1.11 or greater.
    - Remove `inputs.path` field.
    - Remove the `$GOPATH` prefix from `run.path`
    - Add a `caches` section to preserve the resolved dependecies between builds, thus avoiding dowloading them each time.

   Example `/ci/build.yml` after applying the changes above:
    ```yaml
    platform: linux

    image_resource:
      type: docker-image
      source:
        repository: golang
        tag: 1.12.0

    inputs:
      - name: dp-recipe-api

    outputs:
      - name: build

    caches:
      - path: go/

    run:
      path: dp-recipe-api/ci/scripts/build.sh
    ```
- Remove the `$GOPATH/src/github.com/ONSdigital/` pushd path prefix from
    - `ci/scripts/build.sh`
    - `ci/scripts/unit.sh`

   Example `/ci/scripts/build.sh` after applying the changes above:
   ```sh
   #!/bin/bash -eux

   cwd=$(pwd)

   export GOPATH=$cwd/go
   
   pushd dp-recipe-api
     make build && mv build/$(go env GOOS)-$(go env GOARCH)/* $cwd/build
     cp Dockerfile.concourse $cwd/build
   popd
   ```

Commit and push your changes and it should build successfully in CI.

If you encounter and issues not covered in this guide or think something is missing please open a PR on this guide
 adding any missing/useful information.
