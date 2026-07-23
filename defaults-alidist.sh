package: defaults-alidist
version: v1

# Legacy (aliBuild) build variant. Select with:  bits build --defaults alidist
# (bits prepends the release base, so this is really release::alidist).
#
# It does two things, both so bits reuses the prebuilt alibuild-repo tarballs
# instead of rebuilding:
#   * requires the alidist.bits provider, which supplies the alidist recipes AND
#     declares read_store: <alibuild-repo> — the read-only store those tarballs
#     live in (bits reads from it and writes freshly-built packages to the
#     community store).
#   * system: legacy_initdotsh: true — keep the pre-modules build-time init.sh,
#     so package hashes are byte-identical to classic aliBuild and match the
#     tarballs in that store. Without this, the modules-mode env marker changes
#     the hash and nothing is reused.
#
# NOTE: for reuse to actually hit, the hashed inputs (env: flags, recipe
# content, dependency graph) must match how the alibuild-repo tarballs were
# built. If the release base injects flags that classic aliBuild did not, the
# hashes diverge and bits rebuilds — expected, not an error.
system:
  legacy_initdotsh: true

requires:
  - alidist.bits
---
