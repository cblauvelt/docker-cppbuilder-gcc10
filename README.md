# docker-cppbuilder-gcc10

A docker container for building C++ projects with GCC10 that targets amd64. This is to build the repository at [https://hub.docker.com/repository/docker/cblauvelt/cpp-builder-gcc10](https://hub.docker.com/repository/docker/cblauvelt/cpp-builder-gcc10)

## Component Versions

| Package | Version                                   |
| ------- | ----------------------------------------- |
| GCC     | gcc (Ubuntu 10.3.0-1ubuntu1~20.04) 10.3.0 |
| CMake   | cmake version 3.22.2                      |
| Conan   | Conan version 1.44.1                      |

## How to Use

This container is meant to be used as a builder for github workflows. Below is a sample workflow configuation that uses cmake and conan.

```yaml
name: C/C++ CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    container: cblauvelt/cppbuilder-gcc10:latest
    steps:
      - uses: actions/checkout@v2
      - name: configure
        run: cmake -DCMAKE_BUILD_TYPE=Release -G Ninja
      - name: build
        run: cmake --build .
      - name: test
        run: ctest -C Release -T test --output-on-failure --timeout 10
```
