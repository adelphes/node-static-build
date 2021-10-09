node-static-build

A set of statically compiled [NodeJS](https://nodejs.org) binaries.

These binaries are built by compiling and statically linking the NodeJS source tar files.

### Requirements
- apt-get build-essential python


### Build Notes
- v14 needs the `gen-regexp-special-case` target linked against shared libraries (the static version segfaults)
