# alice.bits

Recipes and defaults for building the ALICE software stack (O2, O2Physics and their
dependencies) with [bits](https://github.com/bitsorg/bits). This repository is thin: the
ALICE recipes themselves live in [alisw/alidist](https://github.com/alisw/alidist), which
the [bits-providers](https://github.com/bitsorg/bits-providers) registry exposes as the
shared recipe pool `alidist.bits`. `alice.bits` adds what bits needs on top of it: the base
defaults with the ALICE CVMFS layout, the aliBuild-compatible `alidist` variant and two
temporary recipe fixes (see [Files](#files)). Everything else (`O2`, `O2Physics`, `ROOT`,
the defaults `o2`, `o2-epn`, ...) comes from alidist.

## Two ways to build ALICE software

bits can be driven in two ways (see
[Front-end choice](https://github.com/bitsorg/bits/blob/main/docs/REFERENCE.md#front-end-choice-native-bits-provider-path-vs-alibuild-legacy-path)
in the bits reference):

- **Native `bits` with `alice.bits`** (recommended, and what the bits-console CI uses). bits
  loads the provider registry, which brings in alidist at the branch the registry names
  (`master`), together with the fixes and the CVMFS layout in this repository.
- **The `aliBuild` front-end with an `alidist` checkout** (legacy). The `aliBuild` script
  shipped with bits keeps the classic workflow: no registry, recipes from a local `alidist`
  checkout, legacy `init.sh`, `VO_ALICE@pkg::version` names in `aliBuild q` and the
  `alisw/<distro>-builder` images for `--docker`. This repository is not used on that path.

## Prerequisites

- bits installed as described in the
  [bits README](https://github.com/bitsorg/bits#installation); this also puts the `aliBuild`
  wrapper on your `PATH`. Check the machine with `bits doctor`.
- A platform alidist supports. The bits-console ALICE builds use these architectures and
  builder images:

  | Platform | `--architecture` | Builder image |
  |---|---|---|
  | EL9, x86-64 | `slc9_x86-64` | `registry.cern.ch/alisw/slc9-builder` |
  | EL9, ARM64 | `slc9_aarch64` | `registry.cern.ch/alisw/slc9-arm-builder` |
  | EL8, x86-64 | `slc8_x86-64` | `docker.io/alisw/slc8-builder` |
  | Ubuntu 22.04, x86-64 | `ubuntu2204_x86-64` | `registry.cern.ch/alisw/ubuntu2204-builder` |
  | Ubuntu 24.04, x86-64 | `ubuntu2404_x86-64` | `registry.cern.ch/alisw/ubuntu2404-builder` |

  Use these aliBuild-style names: the alidist recipes test `$ARCHITECTURE` and only
  recognise `slc*` and `ubuntu*` values. On a matching host bits detects them itself.
  EL10 and Ubuntu 26.04 are not supported by alidist yet.
- O2Physics is large: the alidist variant allows 5 GiB per compile job for it, so plan on
  enough memory for the number of jobs you run (see
  [Build memory-hungry packages](https://github.com/bitsorg/bits/blob/main/docs/COOKBOOK.md#build-memory-hungry-packages-without-exhausting-ram)).

## Getting started with native bits

Work in a directory that holds the recipe checkout, your development checkouts and the
`sw` work directory side by side, as with aliBuild:

```bash
mkdir alice && cd alice
bits init alice.bits                  # or: git clone https://github.com/bitsorg/alice.bits
bits use build -c alice.bits --defaults alidist::o2
bits build --dry-run O2Physics        # optional: what would be reused and what built
bits build O2Physics                  # alidist is fetched automatically
bits enter O2Physics/latest           # sub-shell with O2Physics loaded; leave with `exit`
```

`bits use build` records the options once for this directory (saved in `./.bitsuse`). For a
container build, record instead, e.g. on an EL9 x86-64 host:
`bits use build -c alice.bits --defaults alidist::o2 --architecture slc9_x86-64 --docker --docker-image registry.cern.ch/alisw/slc9-builder`.
To build elsewhere, `export BITS_WORK_DIR=/path/to/sw`.

`--defaults alidist::o2` loads `release` (this repository), the `alidist` variant (this
repository) and alidist's `o2` defaults. `O2` builds the same way. Pick another alidist
flavour by replacing `o2`, e.g. `alidist::o2-epn`; packages reject flavours they do not
list in their `valid_defaults`.

To develop a package, check out its source next to the recipes and rebuild; this works for
packages whose recipe is in alidist too:

```bash
bits init -c alice.bits --defaults alidist::o2 O2Physics   # writable checkout in ./O2Physics
bits build O2Physics                  # builds your checkout
```

## Getting started with aliBuild

```bash
mkdir alice && cd alice
aliBuild init                         # clone alisw/alidist into ./alidist
aliBuild build O2Physics --defaults o2
aliBuild init O2Physics               # optional: development checkout
bits enter O2Physics/latest
```

`aliBuild --docker` uses the `alisw/<distro>-builder` image for the architecture by default.
The build-time environment is the classic aliBuild one, so bits and aliBuild produce the
same package hashes and can share tarballs.

## Notes for ALICE users

- **CVMFS layout.** Published packages go to
  `/cvmfs/bits.cern.ch/alice/<install-dir>/Packages/<pkg>/<version>`, with modulefiles in
  `/cvmfs/bits.cern.ch/alice/<install-dir>/Modules/modulefiles/<pkg>` and
  architecture-independent packages under `/cvmfs/bits.cern.ch/alice/noarch/`. The
  install directory follows the OS-first ALICE convention (`el9-x86_64`, `el9-aarch64`,
  `ubuntu2404_x86_64`), not the architecture string. The prefix
  `/cvmfs/bits.cern.ch/alice` must match the `cvmfs_prefix` that bits-console sets for ALICE;
  a build whose prefix disagrees refuses to publish.
- **Publishing** is done from [bits-console](https://gitlab.cern.ch/buncic/bits-console),
  which builds with `--defaults alidist::<flavour>` on the platforms above. To check where a
  package would land, use
  [`bits cvmfs-path`](https://github.com/bitsorg/bits/blob/main/docs/REFERENCE.md#bits-cvmfs-path).
- **Changing defaults.** `defaults-release.sh` here replaces alidist's file of the same name;
  keep the two in step when alidist changes its base flags.

## Files

| File | Role |
|---|---|
| `defaults-release.sh` | Base defaults: compiler flags and disabled packages taken over from alidist, the ALICE CVMFS layout, and `requires: alidist.bits`, so every build pulls in alidist. |
| `defaults-alidist.sh` | The aliBuild-compatible build variant: legacy build-time `init.sh` (alidist-compatible hashes), `CMAKE_PREFIX_PATH` exported at build time, and 5 GiB of memory per compile job for O2Physics. |
| `grpc.sh`, `vecgeom.sh` | Temporary copies of the alidist recipes with a build fix each. Because this repository is searched before alidist, they shadow the alidist versions; they will be removed once the fixes are merged upstream. |

## More information

- [alisw/alidist](https://github.com/alisw/alidist): the ALICE recipes;
  [bits-providers](https://github.com/bitsorg/bits-providers): the registry entries
  `alice.bits` and `alidist.bits`
- bits [ALICE: the aliBuild workflow](https://github.com/bitsorg/bits/blob/main/docs/USERGUIDE.md#alice-the-alibuild-workflow),
  [Check out a recipe repository and develop against it](https://github.com/bitsorg/bits/blob/main/docs/COOKBOOK.md#check-out-a-recipe-repository-and-develop-against-it),
  [Docker Support](https://github.com/bitsorg/bits/blob/main/docs/REFERENCE.md#22-docker-support)
- bits [User Guide](https://github.com/bitsorg/bits/blob/main/docs/USERGUIDE.md),
  [Cookbook](https://github.com/bitsorg/bits/blob/main/docs/COOKBOOK.md),
  [Reference](https://github.com/bitsorg/bits/blob/main/docs/REFERENCE.md)
- [bits-console](https://gitlab.cern.ch/buncic/bits-console): CI builds and CVMFS publishing

## License

This repository does not contain a LICENSE file yet.
