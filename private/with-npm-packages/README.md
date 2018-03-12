# Experiment with NPM packages

The experiment is meant to shape and test a complex infrastructure with a meteor app and NPM packages, and how it will improve in comparison of [using meteor packages](../with-meteor-packages/README.md).

## Structure

The structure of the app in terms of dependencies are:

``` bash
app
  - NPM package a
     - NPM package b
  - NPM package b
```

- Use [lerna](https://lernajs.io/) to manage local NPM packages
- Expose the "dist" folder as the main entry point of the packages.
- Describe the package modules using ES6 within the "src" folder.

## Compilation process

The process to compile the packages on code change is as follows.

1 - Lerna has created symbolic links from `packages/**` to `node_modules/**`. So any change on the packages will make the meteor builder to react.
1 - On package code change, Babel transpile changed ES6 modules within "src" to plain old ES5 JavaScript within "dist" folder.
2 - Meteor builder remains idle as "src" folder is ignored using `.meteorignore` file
3 - Once babel transpilation is done, Meteor detects changes on "dist" folder of the package and compiles the app.

## Setup

To get ready the environment to perform the experiment, you first have to bootstrap the app by running the next command.

``` bash
./bootstrap
```

 The packages will be integrated in the app as NPM packages via lerna. Then, use the `fakeFiles.sh` script, which populates of modules the app and packages by the given input.

``` shell
./fakeFiles <n-app-files> <n-package-a-files> <n-package-b-files>
```

Then the meteor app can be run and profiles are generated to measure the times on load and rebuild the app.

``` bash
./start
```

I used [a module](https://www.npmjs.com/package/concurrently) that enable us to run different compilation processes in parallel, proving the its own way to identify the flow and times of the proccesments. The distinguision has been made between the meteor process to build the app (`app` tag), and the babel processes to transpile each of the packages (`package-a` and `package-b` tags).

Besides, sometimes, when testing with large amount of files you may get your Meteor app instance lagged on rebuild. It consumes so many memory resources, to overcome this issue you can expand your memory available for the node processes by running:

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

| n  | App files | Package #A files | Package #B files | Change on | Total |
|----|-----------|------------------|------------------|-----------|-------|
| 1  |    1000   |         1        |         1        |    app    | 2543  |
| 2  |    5000   |         1        |         1        |    app    | 6519  |
| 3  |    1000   |       5000       |         1        |    app    | 3405  |
| 4  |    1000   |       5000       |         1        |    p#A    | 2091  |
| 5  |    5000   |       1000       |         1        |    app    | 6602  |
| 6  |    5000   |       1000       |         1        |    p#A    | 3955  |
| 7  |    1000   |       5000       |       1000       |    app    | 3547  |
| 8  |    1000   |       5000       |       1000       |    p#A    | 1569  |
| 9  |    1000   |       5000       |       1000       |    p#B    | 1528  |
| 10 |    1000   |       5000       |       5000       |    app    | 4547  |
| 11 |    1000   |       5000       |       5000       |    p#A    | 3365  |
| 12 |    1000   |       5000       |       5000       |    p#B    | 3127  |

> Note: The times showed in the table above correspond to the times on code change with meteor cached.

### Analysis

After the previous results on the experiment we can clearly see that:

- Changing on package is faster than doing it on app level. The reason for that is that with babel compilation we have gained paralelism in package compilation and transpilation on modules on demand. Meteor only has to put together the app modules and NPM dependencies. (See `3` and `4`, and `10`, `11` and `12`).

In comparision with [the previous experiment](../with-meteor-packages/README.md#Analysis), we can clearly see that:

- Meteor apps are better optimized than meteor packages, but meteor builder is a bit outdated in terms of project construction. For the moment, we can only ensure that having NPM packages and an exernal way to do ES6 transpilation for those, is better than having Meteor to handle in its own means.

As always, during the experiment I also noted that:

- Having large amount of files and links between them is critical on app level and makes the initial load of the builder (timings without the cache) to get so much time to rebuild (many many minutes! insane!).

### Improvements

Meteor builder seems to not be optimized on projects with large amount of files. For that I really think that adopting this approach should consider the next improvements:

- Describe the less modules and files on app level. The application level should only have modules that depends on build-in Meteor stuff (like subscriptions, collections and etc) and the startup procedures. Maybe this can be enhanced further by describing the modules that depend on Meteor in NPM packages but as module factories, and use the app level to instantiate those modules by passing the needed Meteor context.

- Adopt Webpack for package compilation is not possible apparently, as Webpack not only transpile ES6, also perform Meteor builder work, that is joining all modules together. But in our package level we want to have modules and submodules defined, not only single entry points generated by Webpack build. That is why babel transpilation is our best bet so far.

- Use [gulpjs](https://gulpjs.com/) task runner to improve the definition of babel transpilation to all packages within `/packages` as supports wildcard definitions.

- Include `babel-transform-imports` plugin to translate our index imports to specific ones, provided that [I implemented regex support for it](https://bitbucket.org/amctheatres/babel-transform-imports).
