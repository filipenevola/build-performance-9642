# Experiment with Meteor packages

The experiment is meant to stress a meteor app with simple modules, which are created as independent files and imported as a whole using index files. Concretly, this is an attempt to analyze the performance of meteor builder on having large amount of files in complex meteor infrastructures, composed by meteor packages and dependencies between them.

## Structure

The structure of the app in terms of dependencies are:

``` bash
app
  - package a
     - package b
  - package b
```

## Setup

To get ready the environment to perform the experiment, use the `fakeFiles.sh` script, which populates of modules the app and packages by the given input.

``` shell
./fakeFiles <n-app-files> <n-package-a-files> <n-package-b-files>
```

Then the meteor app is run and profiles are generated to measure the times on load and rebuild the app.

``` bash
export METEOR_PROFILE=1 # tell the meteor builder to output the profiles logs
yarn start # start the app
```

Sometimes, when testing with large amount of files you may get your Meteor app instance lagged on rebuild. It consumes so many memory resources, to overcome this issue you can expand your memory available for the node processes by running:

``` bash
export TOOL_NODE_FLAGS="--max_old_space_size=4096" # can be needed on secenarios with many files
```

## Experiment

The experiment consists in several in testing the rebuild performance on different file scenarios for the app level and packages.

The tests have been performed on the next computer specs:

``` shell
MacBook Pro (Retina, 15-inch, Mid 2015)
Processor 2.8 GHz Intel Core i7 4 cores
Memory 16 GB 1600 MHz DDR3
SSD
```

| n  | App files | Package #A files | Package #B files | Change on | PreProjBuild | RebuildApp | ServerStartup | Total |
|----|-----------|------------------|------------------|-----------|--------------|------------|---------------|-------|
| 1  |    1000   |         1        |         1        |    app    |      283     |     818    |      620      |  1721 |
| 2  |    3000   |         1        |         1        |    app    |      555     |    3,005   |      598      |  4158 |
| 3  |    1000   |       5000       |         1        |    app    |     1,074    |    2,405   |      613      |  4092 |
| 4  |    1000   |       5000       |         1        |    p#A    |     5,454    |    2,740   |      614      |  8808 |
| 5  |    5000   |       1000       |         1        |    app    |      610     |    3,366   |      588      |  4564 |
| 6  |    5000   |       1000       |         1        |    p#A    |     1,463    |    3,536   |      590      |  5589 |
| 7  |    1000   |       5000       |       1000       |    app    |     1,170    |    2,774   |      586      |  4530 |
| 8  |    1000   |       5000       |       1000       |    p#A    |     4,646    |    3,724   |      617      |  8987 |
| 9  |    1000   |       5000       |       1000       |    p#B    |     2,295    |    2,683   |      580      |  5558 |
| 10 |    1000   |       5000       |       5000       |    app    |     2,141    |    3,879   |      591      |  6611 |
| 11 |    1000   |       5000       |       5000       |    p#A    |     6,188    |    5,443   |      633      | 12264 |
| 12 |    1000   |       5000       |       5000       |    p#B    |     6,351    |    5,235   |      620      | 12206 |