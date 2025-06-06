package: AliGenO2
version: "v%(year)s%(month)s%(day)s"
requires:
  - DPMJET
  - POWHEG
  - pythia
  - ThePEG
  - Rivet
  - SHERPA
  - lhapdf-pdfsets
  - JETSCAPE
  - CRMC
  - EPOS4:(?!.*aarch64)
  - EPOS4HQ:(?!.*aarch64)
  - EVTGEN:(?!osx)
  - STARlight:(?!osx)
  - Upcgen:(?!osx)
  - Graniitti:(?!osx)
  - nOOn:(?!osx)
build_requires:
  - alibuild-recipe-tools
---
#!/bin/bash -ex

# Modulefile
moduledir="$INSTALLROOT/etc/modulefiles"
mkdir -p "$moduledir"
alibuild-generate-module > "$moduledir/$PKGNAME"
