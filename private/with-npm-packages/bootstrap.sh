#!/usr/bin/env bash

meteor remove a b
lerna add a b --scope=build-performance-9642
lerna bootstrap
