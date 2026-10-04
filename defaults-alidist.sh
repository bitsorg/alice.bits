package: defaults-alidist
version: v1

# ALICE on bits: build with  bits build --defaults alidist::<flavour> PKG  (e.g. alidist::o2).
# bits prepends the release base (defaults-release.sh here: CVMFS layout only), so
# the chain is release::alidist::o2. This variant adds the bits knobs that keep
# builds aliBuild-compatible; everything else comes from the alidist flavour.

# A structural overlay, not a build flavour: packages' valid_defaults ignore it.
valid_defaults_exempt: true

system:
  # aliBuild-compatible build-time init.sh, so alidist tarballs stay reusable.
  legacy_initdotsh: true

overrides:
  O2Physics:
    mem_per_job: "5 GiB"

env:
  BITS_LEGACY_CMAKE_PREFIX_PATH: "1"

requires:
  - alidist.bits
---
