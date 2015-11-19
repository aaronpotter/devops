# Devop's Scipts, Documentation, and Configs

## Overview

A repo for collaborative knowledge transfer.

## Install

### Requirements

- [Brew](http://brew.sh/)
- Ruby lastest stable
- [Bundler](http://bundler.io/)
- [gnu sed](http://www.gnu.org/software/sed/)
  - if mac, `brew install gnu-sed`

### Steps

1. run `bundle`
1. DONE!

## Usage

### Copyright Files

    copyright_app [options]
      -e, --file_ext       [required] the file extention to add the copyright message to.
      -d, --directory      [optional] directory to search. (default: [CURRENT_DIRECTORY])
      -v, --version
      -h, --help           Display this help message.

### Domain Cutover, version 1.0.0

    domain_tover [options]
      -c, --config_file      [required] the config yaml to use to define the domains to cutover.
      -p, --profile          [required] The name of the AWS credential profile to use.
      -d, --dryrun           do a dry run
      -v, --version
      -h, --help             Display this help message.
# devops
