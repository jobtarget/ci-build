#!/bin/sh
set -eu

aws ecr get-login-password | docker login --username AWS --password-stdin $1