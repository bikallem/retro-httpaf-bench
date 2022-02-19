#!/bin/bash
set -xe

run_duration="${RUN_DURATION:-30}"

export GOMAXPROCS=1
export COHTTP_DOMAINS=24
export HTTPAF_DOMAINS=24
export OCAMLRUNPARAM="v=0x400"

rm -rf output/*
mkdir -p output

# for cmd in "cohttp_eio_parser_http.exe" "httpaf_eio.exe" "rust_hyper.exe" "cohttp_lwt_unix.exe" "httpaf_lwt.exe" "httpaf_effects.exe" "nethttp_go.exe" "httpaf_shuttle_async.exe"; do
# for cmd in "cohttp_eio_parser_angstrom.exe" "cohttp_eio_parser_http.exe" "httpaf_eio.exe" "rust_hyper.exe" "cohttp_lwt_unix.exe" "httpaf_lwt.exe" "httpaf_effects.exe" "nethttp_go.exe" "httpaf_shuttle_async.exe"; do
# for cmd in "httpaf_eio.exe" "httpaf_effects.exe" "httpaf_shuttle_async.exe" "httpaf_lwt.exe" "cohttp_eio.exe" "cohttp_lwt_unix.exe"; do
# for cmd in "httpaf_eio.exe" "cohttp_eio_parser_http.exe" "cohttp_eio_parser_custom.exe" ; do
# for cmd in "cohttp_eio_parser_http.exe"; do
for cmd in "cohttp_eio_parser_custom.exe" ; do
# for cmd in "httpaf_eio.exe" ; do
  # for rps in 300000 400000 800000 1500000; do
  for rps in 1500000; do
    for cons in 1000; do
      ./build/$cmd &
      running_pid=$!
      sleep 2;
      ./build/wrk2 -t 24 -d${run_duration}s -L -s ./build/json.lua -R $rps -c $cons http://localhost:8080 > output/run-$cmd-$rps-$cons.txt;
       curl http://localhost:8080/exit
      # kill ${running_pid};
      sleep 1;
    done
  done
done

source build/pyenv/bin/activate
mv build/parse_output.ipynb .
jupyter nbconvert --to html --execute parse_output.ipynb
mv parse_output* output/
