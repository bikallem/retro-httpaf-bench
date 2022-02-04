#!/bin/bash

set -e

export OPAMROOT=`pwd`/_opam

# Build effects http server with multicore
opam switch 4.12.0+domains+effects
cd httpaf-effects && opam exec -- dune build --profile=release
mv _build/default/wrk_effects_benchmark.exe ../httpaf_effects.exe

# Use trunk 4.10.0 for the lwt http server
opam switch 4.12.0
cd ../httpaf-lwt && opam exec -- dune build --profile=release
mv _build/default/httpaf_lwt.exe ..

opam pin add git@github.com:mirage/ocaml-cohttp.git -y
cd ../cohttp-lwt-unix && opam exec -- dune build --profile=release
mv _build/default/cohttp_lwt_unix.exe ..

cd ../httpaf-shuttle-async && opam exec -- dune build --profile=release
mv _build/default/httpaf_shuttle_async.exe ..

# Now we build the go one with 1.15
cd .. && go/bin/go build nethttp-go/httpserv.go
mv httpserv nethttp_go.exe

# Last we build rust-hyper
cd rust-hyper
cargo build --release
mv target/release/rust-hyper ../rust_hyper.exe
cd ..
