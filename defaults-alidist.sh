package: defaults-alidist
version: v1

# Legacy (aliBuild) build variant. Select with:  bits build --defaults alidist
# (bits prepends the release base, so this is really release::alidist).
#
# It does two things:
#   * requires the alidist.bits provider, which supplies the alidist recipes.
#   * system: legacy_initdotsh: true — keep the pre-modules build-time init.sh,
#     so the build environment matches classic aliBuild.
#
# Packages are built from the alidist recipes and published to the community
# signed store like any other bits build. bits does NOT reuse the public
# alibuild-repo tarballs: that store is unsigned, and bits only reuses content
# from its own signed store. So an alidist build compiles from source and the
# results are certified and published into the common repository.
#
# valid_defaults_exempt marks this as a structural/overlay layer, not a build
# flavor: a package's valid_defaults gate (e.g. O2Physics -> [o2, o2-epn, ...])
# is checked only against flavor defaults, so chaining alidist::<flavor> (which
# bits expands to release::alidist::<flavor>) does not fail on the alidist or
# release layers.
valid_defaults_exempt: true

system:
  legacy_initdotsh: true

requires:
  - alidist.bits
---
