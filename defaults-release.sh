package: defaults-release
version: v1

# CVMFS path templates
system:
  # {prefix} is the group ROOT (auth boundary). bits-console (ui-config.yaml:
  # cvmfs_prefix) injects the authoritative value, which WINS; the value below MUST
  # match it (kept in sync by bits-admin PR) or an injected build refuses to publish.
  # It lets local `bits build` (no injection) work and is a checked declaration.
  prefix:                     "/cvmfs/bits.cern.ch/alice"
  cvmfs_user_prefix:          "{prefix}/user"
  # ALICE lays CVMFS out by the OS-first install-dir (el9-x86_64, el9-aarch64,
  # ubuntu2404_x86_64 — cf. /cvmfs/alice.cern.ch/el*), NOT the arch-first platform
  # NAME (x86_64-el9). {install_dir} is the platforms-table install_dir (resolved
  # identically by `bits cvmfs-path` and the publish _expand_tmpl); {platform}
  # would give x86_64-el9. Decoupled from --architecture (now the aliBuild-native
  # slc9_x86-64 for recipe compatibility), which never enters the publish path.
  cvmfs_releases_template:    "{prefix}/{install_dir}/Packages/{pkg}/{tag}"
  cvmfs_modules_template:     "{prefix}/{install_dir}/Modules/modulefiles/{pkg}"
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
