package: defaults-alidist
version: v1

# Legacy (aliBuild) build variant. Select with:  bits build --defaults alidist
# (bits prepends the release base, so this is really release::alidist).

# valid_defaults_exempt marks this as a structural/overlay layer, not a build
# flavor
valid_defaults_exempt: true

system:
  legacy_initdotsh: true

overrides:
  O2Physics:
    mem_per_job: "5 GiB"

env:
  BITS_LEGACY_CMAKE_PREFIX_PATH: "1"

requires:
  - alidist.bits
---
