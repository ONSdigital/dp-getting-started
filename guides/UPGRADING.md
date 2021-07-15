# Technology Upgrading Policy

## Overview

Our approach to version upgrades is contingent on the technology in question. Details of which are outlined below, per technology and language.

If you notice any upgrades that are not covered by this policy (including major versions of DBs becoming available), please
raise them on the [20% board](https://trello.com/b/5G8rf9cm/20-time-backlog) for triage.
Further reading on [contributing to 20% backlog](../training/culture-and-process/CONTRIBUTING_TO_20%_BACKLOG.md).

### Legacy apps

We **do not** update dependencies in our legacy apps unless there is a **high or severe security vulnerability** present.

Current legacy apps:

- [babbage](https://github.com/ONSdigital/babbage)
- [zebedee](https://github.com/ONSdigital/zebedee)
- [the train](https://github.com/ONSdigital/the-train)
- [brian](https://github.com/ONSdigital/project-brian)
- [florence legacy app](https://github.com/ONSdigital/florence) - this can be found in florence's `src/legacy` directory

### Go

- When a new Go version is released, wait for a patch release (i.e., `0.X.1`) before upgrading. For instance, if it's a choice between Go `1.15.11` and `1.16.0`, choose `1.15.11`.
- Ensure the `go.mod` version is also bumped within applications.
- We specifically should check that the [Go Docker image](https://hub.docker.com/_/golang) for that version is also available.

### Java

- Upgrade to the latest LTS version once a patch version is available. Check [AdoptOpenJDK](https://adoptopenjdk.net/index.html?variant=openjdk16&jvmVariant=hotspot) for latest versions.

### Spring Boot

- Upgrade to the latest minor version once a patch version is available - [versions here](https://mvnrepository.com/artifact/org.springframework.boot/spring-boot)

### Node

- We should use the latest `active` LTS version, waiting for a patch to the release first before adopting. Details can be found on the [nodejs](https://nodejs.org/en/) website.

### React

- Upgrade to the latest minor version once a patch is available; you can find them [here](https://reactjs.org/versions).

### Frameworks and libraries

- Choose the latest minor version with a patch. It is also down to senior developers to determine when major version upgrades are worth doing.

### Platform Technologies

- Upgrade to the latest version once a patch version is available - [technologies listed here](/guides/TECHNOLOGIES.md#platform).

**note**: there are some platform technologies where versions may be pinned (Terraform, for instance). Any updates in these circumstances will need discussion and planning with Tech Leads.

### Databases

- Stay up-to-date on patches, but all minor and major updates will need discussion and planning due to dependency and clients.
