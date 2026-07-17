package: defaults-release
version: v1

# CVMFS path templates
system:
  # {prefix} is the group ROOT (auth boundary). bits-console (ui-config.yaml:
  # cvmfs_prefix) injects the authoritative value, which WINS; the value below MUST
  # match it (kept in sync by bits-admin PR) or an injected build refuses to publish.
  # It lets local `bits build` (no injection) work and is a checked declaration.
  prefix:                     "/cvmfs/sft-nightlies-test.cern.ch/bits/alice"
  cvmfs_user_prefix:          "{prefix}/user"
  cvmfs_releases_template:        "{prefix}/{platform}/Packages/{pkg}/{tag}"
  cvmfs_modules_template:     "{prefix}/{platform}/Modules/modulefiles/{pkg}"
  cvmfs_shared_path_template: "{prefix}/noarch/{pkg}/{tag}"

env:
  CXXFLAGS: "-fPIC -g -O2 -std=c++11"
  CFLAGS: "-fPIC -g -O2"
  CMAKE_BUILD_TYPE: "RELWITHDEBINFO"

disable:
  - RooUnfold
  - treelite

requires:
  - alidist.bits  
---
