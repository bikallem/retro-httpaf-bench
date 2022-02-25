FROM rust:1.44

WORKDIR /src
COPY . /src

RUN cargo clean
RUN RUSTFLAGS="-C target-cpu=native" cargo build --release

RUN mv target/release/rust-hyper /src/rust-hyper.exe
