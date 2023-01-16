#!/usr/bin/env bash
ssh-add -q $(find ~/.ssh/ -name "*.pub" | sed 's:\.pub$::') </dev/null
