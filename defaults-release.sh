package: defaults-release
version: v1

# bits always puts `release` at the base of the chain (release::alidist::o2). This
# file shadows alidist's defaults-release.sh, which is the legacy ROOT 5/AliRoot
# flavour and would otherwise pin ROOT 5, OpenSSL 1.0.2 etc. under every build.
# aliBuild never layers it under --defaults o2, so neither do we. It holds only the
# alidist dependency (the ALICE CVMFS layout is in cvmfs.yaml); compiler flags,
# disabled packages and version pins come from the alidist flavour (defaults-o2.sh, ...).

requires:
  - alidist.bits
---
