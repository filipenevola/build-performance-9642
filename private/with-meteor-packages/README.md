# Experiment with Meteor packages

The experiment is meant to stress a meteor app with simple modules, which are created as independent files and imported as a whole using index files. Concretly, this is an attempt to analyze the performance of meteor builder on having large amount of files in complex meteor infrastructures, composed by meteor packages and dependencies between them.

## Structure

The structure of the app in terms of dependencies are:

``` bash
app
  - Meteor package a
     - Meteor package b
  - Meteor package b
```

- Expose the "src" folder as the main entry point of the packages.
- Describe the modules using ES6 within the "src" folder.
- Ignore "dist" folder as Meteor resolves ES6 on the packages.

## Setup

To get ready the environment to perform the experiment, you first have to bootstrap the app by running the next command.

``` bash
./bootstrap.sh
```

 The packages will be integrated in the app as meteor packages. Then, use the `fakeFiles.sh` script, which populates of modules the app and packages by the given input.

``` shell
./fakeFiles.sh <n-app-files> <n-package-a-files> <n-package-b-files>
```

Then the meteor app can be run and profiles are generated to measure the times on load and rebuild the app.

``` bash
./start.sh
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

The results are available on `logs/` folder, but the next table sums it up and serve for the analysis.

| n  | App files | Package #A files | Package #B files | Change on | PreProjBuild | RebuildApp | ServerStartup | Total |
|----|-----------|------------------|------------------|-----------|--------------|------------|---------------|-------|
| 1  |    1000   |         1        |         1        |    app    |      283     |     818    |      620      |  1721 |
| 2  |    5000   |         1        |         1        |    app    |      555     |    3,005   |      598      |  4158 |
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

> Note: The times showed in the table above correspond to the times on code change with meteor cached.

### Analysis

After the previous results on the experiment we can clearly see that:

- Move files from the app to package level (see `2` and `3`) has no effect on the rebuild time when changing files at app level. However, when changing a package file the time is doubled, since Meteor gets extra time to copy the package's files to build (see `PreProjBuild` at `4`).

- Keep files on app level is better than keep them on package, at least when acting on the shared code added to the package. (compare `4` with `6`)

- The more files you have on packages that are interconnected, the more time is spent by the builder on change package's code. (compare `8` and `9` with `11` and `12`).

During the experiment I also noted that:

- Having large amount of files on packages makes the initial load of the builder (timings without the cache) to get so much time to rebuild (minutes!) in comparison on doing it on the app.

- Exporting package's code as client and server will impact on add more time on `RebuildApp`. I dediced to test only the client impact as is something closer on what happens in our environment. However, we must always ensure that modules are exported properly to its proper end.

- Importing in the server code a package via the `mainModule` produces to load eagerly all modules involved, adding time to the `ServerStartup` phase.

### Next experiments

Meteor builder seems to not be optimized on use packages. Besides, for the best optimization we should ensure that we load by demand the modules needed and not more than those to alliviate the build process. For these the next experiments would be around:

- Consider to use NPM packages instead of meteor packages here, using lernajs to manage the project.
- Compile NPM packages with latest Webpack as we may not have support of having NPM ES6 modules to be consumed in Meteor.
- Include `babel-transform-imports` plugin to translate our index imports to specific ones, provided that [I implemented regex support for it](https://bitbucket.org/amctheatres/babel-transform-imports/pull-requests/8/support-regular-expressions/diff). This would be useful for others apps that are not using all modules but requires to set a convention.
