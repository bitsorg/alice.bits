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
system:
  legacy_initdotsh: true

requires:
  - alidist.bits
---
