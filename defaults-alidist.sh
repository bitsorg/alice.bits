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
  # Per-job memory footprint assumed for recipes without mem_per_job (all of
  # alidist — aliBuild has no such field). bits caps $JOBS at
  # available*0.9/this, with `available` clamped to the container's cgroup
  # --memory budget. The bits built-in default of 2 GiB is far too small for
  # O2/O2Physics C++: a single cc1plus was observed at 4.7 GB RSS, so ~25
  # parallel jobs blew through the container cap (cgroup OOM-killed cc1plus).
  # 5 GiB → ~10 jobs on a 57 GB budget, which fits with headroom. Non-hashed
  # build-host policy: tuning this never rebuilds anything.
  mem_per_job_default: "5 GiB"

# Export dependency roots on CMAKE_PREFIX_PATH in each build's init.sh (bits
# knob, read from the hashed env: block so flipping it re-hashes the chain).
# aliBuild's init.sh sets only <PKG>_ROOT, which CMake ignores for projects
# whose cmake_minimum_required predates CMP0074/CMP0144 — under CMake 4 (now
# pinned by alidist) VecGeom's builtin VecCore 0.8.0 (requires 3.9) cannot
# find Vc without it. The runtime modulefiles already carry CMAKE_PREFIX_PATH
# (alibuild-generate-module --cmake); this mirrors that at build time.
env:
  BITS_LEGACY_CMAKE_PREFIX_PATH: "1"

requires:
  - alidist.bits
---
