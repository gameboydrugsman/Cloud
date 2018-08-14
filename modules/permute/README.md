# Puppet-Permute

[![Build Status](https://travis-ci.org/xaque208/puppet-permute.png?branch=master)](https://travis-ci.org/xaque208/puppet-permute)

A puppet utility module to create permutations of a given resource type.

This is useful for generating resources for which there is a set of common as
well as unique parameters for a given set of resources.  Where I have found
this to be most useful is in generating the PXE configurations, where there are
sets of resources that have things in common, but not all resources have all
things in common, so you can't use resource defaults.

