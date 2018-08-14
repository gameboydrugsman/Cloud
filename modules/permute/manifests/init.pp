# Define: Permute
#
# Takes three paramaters.
#
# $resource: the resource type that needs to be generated
# $unique: a hash of unique paramaters that need to be permuted
# $common: a hash of common paramaters to attach to each of the generated resources
#
define permute (
  $resource,
  $unique = {},
  $common = {},
) {

  validate_string($resource)
  validate_hash($unique)
  validate_hash($common)

  resource_permute($resource, $unique, $common)
}
