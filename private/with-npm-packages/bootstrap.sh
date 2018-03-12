#!/usr/bin/env bash

# Remove the packages as Meteor dependecies
meteor remove a b

# Add and creates symbolic links of the NPM packages
lerna add a b --scope=build-performance-9642
lerna bootstrap

# Ignore `src` folder in order to the Meteor builder
# only reacts after babel compilation of NPM modules
rm -rf ../../packages/a/.meteorignore
rm -rf ../../packages/b/.meteorignore
echo "src" > "../../packages/a/.meteorignore"
echo "src" > "../../packages/b/.meteorignore"