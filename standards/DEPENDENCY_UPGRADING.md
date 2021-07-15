Dependency Upgrading Standard
=============================

## General approach

When working on a repository, developers should check that the dependencies of that repository are sufficiently up to
date. The approach to updating the dependencies depends on the type of app and the underlying technology.

There is no formal decision process for upgrading language dependencies. As soon as a newer minor version of a language
is released (providing it is covered by the policy for that language), then you may upgrade it straight away. For 
example, when go@1.x.1 is released then you should use it in your next pull request.

If you notice any upgrades that are not covered by this policy (including major versions of DBs becoming available)
raise them on the [20% board](https://trello.com/b/5G8rf9cm/20-time-backlog) for triage.
Further reading on [contributing to 20% backlog](../training/culture-and-process/CONTRIBUTING_TO_20%_BACKLOG.md).

We don’t update dependencies in legacy apps unless there is a security vulnerability (babbage, zebedee, train, brian,
legacy florence).

## Go based apps and libraries

Go based repositories have their dependencies defined in three different ways.
1. The version of go used to test and build the component (the docker image tag defined in `ci/build.yml` etc. eg. `1.15.8`)
2. The language specification of the module (defined in `go.mod` eg. `1.15`)
3. The versions of each of the module dependencies (defined in `go.mod` and `go.sum`)

### Build and test version (docker image)

The general approach for updating the version of go used to build an app is to update to the latest version of go as
defined [on the `golang` image on docker hub](https://hub.docker.com/_/golang) as long as the patch version is >= 1. 
For example…

| Available docker image tags | Choose… |
| --------------------------- | ------- |
| 1.15.8 , 1.16.0             | 1.15.8  |
| 1.15.9 , 1.16.1             | 1.16.1  |
| 1.15.9 , 1.16.2             | 1.16.2  |

Once the new version of go has been selected it needs to be added to the `ci/build.yml` and `ci/unit.yml` files.

NB. For libraries the version of go will be pinned by the app using the library so for the ci jobs we want to use the 
latest version of go instead. So for libraries only, the tag in the above files should be `latest` instead of a specific
version. 

### Language specification (go.mod)

If the docker tag is upgraded from one minor version to another (eg. from `1.15.x` to `1.16.x`) then the language
specification of the module in `go.mod` should be upgraded as well. Whilst not strictly necessary it helps to keep
things in sync. Note that this must not contain the patch version so should simply be `1.16` etc. not `1.16.2` and can
be updated with the command `go mod edit -go=1.16` or similar.

### Module dependencies

The module dependencies are audited by running `make audit` and also by an audit CI job triggered by PRs. Any vulnerable
dependencies identified should be updated. Other dependencies may be updated as necessary eg. in order to use new
functionality.

To update a specific dependency run `go get -u path.to/some/library` or for a specific version 
`go get path.to/some/library@v1.2.3`. If you want to update all direct dependencies simply run `go get -u ./...`.

This will not update sub-dependencies of dependencies (unless a new version of a dependency requires a new version of a 
sub-dependency). So if after updating there are still vulnerabilities in any of these transitive dependencies there are
two possibilities for resolution.

1. (Preferred) If the vulnerable dependency is being brought in by one of our libraries, then fix the vulnerability in
   the library first and release a new version. This dependency can then be in turn updated in the app using it.
2. If it is not possible to update the direct dependency (say it is an external library which itself has no newer
   version) then you can directly update the vulnerable dependency using `go get path.to/some/library@v1.2.3`

## Java based apps and libraries

latest LTS and wait for a patch (update installing to go from https://adoptopenjdk.net/)

### Module dependencies

The Java apps use the build tool Maven, where dependencies are defined in a `pom.xml` file. Normally there is a single pom.xml file at the root of the project, though there may be multiple if there are sub modules (e.g. Zebedee)

Each dependency in the pom.xml file has a block of XML under the `dependencies` section:

```
    <dependencies>  
        <dependency>
            <groupId>com.google.code.gson</groupId>
            <artifactId>gson</artifactId>
            <version>2.4</version>
        </dependency>
    </dependencies>
```

To run an audit of the dependencies, run the `make audit` command. This is a wrapper for the underlying Maven command `mvn ossindex:audit`

Exclusions for the dependency audit are defined in the pom.xml file, under the configuration section of the `ossindex-maven-plugin`. Below is an example exclusion defined for the elasticsearch dependency. The surrounding XML will most likely exist already, and only the `exlude` block will need adding.

```
   <build>
        <plugins>
            <plugin>
                <groupId>org.sonatype.ossindex.maven</groupId>
                <artifactId>ossindex-maven-plugin</artifactId>
                
                ....
                                
                <configuration>
                   <excludeCoordinates>
                       <exclude>
                           <groupId>org.elasticsearch</groupId>
                           <artifactId>elasticsearch</artifactId>
                           <version>2.1.1</version>
                       </exclude>
                   </excludeCoordinates>
                </configuration>
            </plugin>
        </plugins>
    </build>
```

If the vulnerable dependency is not listed in the pom.xml file, it will be a transitive dependency, meaning it is a dependency of a dependency. In these cases it is useful to use the `mvn dependency:tree` command. This command is run from the directory of the pom.xml file, and will print a tree like representation of dependencies. The output can be searched for the vulnerable dependency, and then the parent of that dependency can be seen. In these cases consider whether updating the parent dependency would be more appropriate. Sometimes updating the parent dependency still does not use a fixed version of the vulnerable dependency. If the vulnerable dependency needs a specific version, create a new dependency entry in the pom.xml which will override the existing version used. It is recommended to only upgrade the minor version if possible, as a major version may include breaking changes.

To see the available versions of a dependency, go to https://mvnrepository.com/ and search the dependency name. When a version is selected, an XML snippet for the dependency will be given under the Maven tab.

Once a dependency has been updated, first ensure the code builds (`make build`), and the tests pass (`make test`). Ideally then the code where the dependency is used will be tested. To determine where a dependency is used, search the codebase for the import statement of that dependency. If it is a transitive dependency, the parent dependency will need to be used in the search.

If there is no exclusion defined in the pom.xml file, it may have been flagged by Github's dependabot tool. The dependabot vulnerabilities can be seen by going to the `/security/dependabot` path of the repository. For example with Zebedee: https://github.com/ONSdigital/zebedee/security/dependabot

Dependabot may have already created a PR with the updated dependency, though it will be that dependency specifically (not considering parent dependencies). It may also not be the latest version, as there may have been a newer version released since the PR was created. A dependabot PR will be automatically closed if the vulnerability gets fixed by another PR.

## Javascript based apps and libraries

### Application dependencies

The Javascript apps use the build tool NPM, where dependencies are defined in a `package.json` file. Normally there is a single `package.json` file at the root of the project, though there may be multiple if there are sub projects (e.g. Florence)

Each dependency in the `package.json` file has an entry under the `dependencies` section:

```
  "dependencies": {
    "react": "^15.6.2",
    ...
  }  
```

To run an audit of the dependencies, run the `make audit` command. This is a wrapper for the underlying command `npx auditjs ossi`

Exclusions for the dependency audit are defined in the `audit-allowlist.json` file. When fixing a vulnerability, make sure any exclusions for that dependency are removed. Below is an example exclusion file with a single exclusion for the moment dependency.

```
{
    "ignore": [
        { "id": "58fdd459-8d4a-4bf6-b106-ef7cff98268c", "package": "moment" }
    ]
}
```

If the vulnerable dependency is not listed in the `package.json` file, it will be a transitive dependency, meaning it is a dependency of a dependency. In these cases it is useful to use the `npm ls` command. This command is run from the directory of the `package.json` file, and will print a tree like representation of dependencies. The output can be searched for the vulnerable dependency, and then the parent of that dependency can be seen. In these cases consider whether updating the parent dependency would be more appropriate. Sometimes updating the parent dependency still does not use a fixed version of the vulnerable dependency. If a transitive dependency needs a specific version, create a new entry under the `resolutions` section of the `package.json`. This will override the existing version used by the parent. It is recommended to only upgrade the minor version if possible, as a major version may include breaking changes.

To see the available versions of a dependency, go to https://www.npmjs.com/ and search the dependency name. For a specific version, select the version tab and then select the version required. Under the install section there will be an example `npm` command to install the dependency at that specific version.

Once a dependency has been updated, first ensure the code builds (`make build`), and the tests pass (`make test`). Ideally then the code where the dependency is used will be tested. To determine where a dependency is used, search the codebase for the import statement of that dependency. If it is a transitive dependency, the parent dependency will need to be used in the search.

If there is no exclusion defined in the pom.xml file, it may have been flagged by Github's dependabot tool. The dependabot vulnerabilities can be seen by going to the `/security/dependabot` path of the repository. For example with Florence: https://github.com/ONSdigital/florence/security/dependabot

Dependabot may have already created a PR with the updated dependency, though it will be that dependency specifically (not considering parent dependencies). It may also not be the latest version, as there may have been a newer version released since the PR was created. A dependabot PR will be automatically closed if the vulnerability gets fixed by another PR.


## Other technologies

### Node 
latest ‘active’ LTS and wait for a patch

### React 
latest minor version and wait for a patch

### Spring boot 
latest minor and wait for a patch

### Frameworks and libraries
latest minor + patch as clean campsite. Down to senior developers to determine when major version upgrades are worth doing

### Platform technologies 
latest + patch

### Databases 
stay up to date on patches, but all minor/major updates will need discussion and planning due to dependency with clients.

### AWS 
managed should just be latest


