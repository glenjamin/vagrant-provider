# Vagrant Provider Swapper

Some rather hacky tricks to swap between different providers for a single
vagrant machine without destroying anything.

Useful for building a VM locally, then pushing up to a cloud provider,
for example.

## Installation

    vagrant plugin install provider

## Usage

```
# list machines and providers
$ vagrant provider list

Machines
--------

default:
    virtualbox (current)
    vmware_fusion
    digital_ocean

# stash the current provider state for later
$ vagrant provider stash [machine-name]

# bring back the named provider state
$ vagrant provider pick <provider> [machine-name]

```