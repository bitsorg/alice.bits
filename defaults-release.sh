package: defaults-release
version: v1

# bits always puts `release` at the base of the chain (release::alidist::o2). This
# file shadows alidist's defaults-release.sh, which is the legacy ROOT 5/AliRoot
# flavour and would otherwise pin ROOT 5, OpenSSL 1.0.2 etc. under every build.
# aliBuild never layers it under --defaults o2, so neither do we. It holds only the
# ALICE CVMFS layout and the alidist dependency; compiler flags, disabled packages
# and version pins come from the alidist flavour (defaults-o2.sh, ...).
system:
  # {prefix} is the group root (auth boundary). bits-console (ui-config.yaml:
  # cvmfs_prefix) injects the authoritative value, which wins; the value below
  # must match it or an injected build refuses to publish.
  prefix:                     "/cvmfs/bits.cern.ch/alice"
  cvmfs_user_prefix:          "{prefix}/user"
  # ALICE lays CVMFS out by the OS-first install dir (el9-x86_64, ubuntu2404_x86_64,
  # as in /cvmfs/alice.cern.ch), not the platform name; {install_dir} comes from
  # the platforms table, independent of the aliBuild-style --architecture.
  cvmfs_releases_template:    "{prefix}/{install_dir}/Packages/{pkg}/{tag}"
  cvmfs_modules_template:     "{prefix}/{install_dir}/Modules/modulefiles/{pkg}"
  cvmfs_shared_path_template: "{prefix}/noarch/{pkg}/{tag}"

requires:
  - alidist.bits
---
