#!/usr/bin/env bash

if [ "$(meteor yarn list | grep -w '[ab]')" ]; then
  meteor yarn remove a b
fi
meteor add a b
