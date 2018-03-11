#!/usr/bin/env bash

# Remove the packages as NPM dependecies
if [ "$(meteor yarn list | grep -w '[ab]')" ]; then
  meteor yarn remove a b
fi

# Add the packages as Meteor dependecies
meteor add a b

# Ignore `dist` folder as Meteor resolves ES6 on the packages
rm -rf ../../packages/a/.meteorignore
rm -rf ../../packages/b/.meteorignore
echo "dist" > "../../packages/a/.meteorignore"
echo "dist" > "../../packages/b/.meteorignore"
