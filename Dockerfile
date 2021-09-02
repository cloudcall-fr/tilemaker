FROM debian:stable-slim
LABEL Description="Tilemaker" Version="2.0.0"

ARG DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ruby-sqlite3 wget build-essential libsqlite3-dev liblua5.1-0 liblua5.1-0-dev libprotobuf-dev libsqlite3-dev protobuf-compiler shapelib libshp-dev libboost-program-options-dev libboost-filesystem-dev libboost-system-dev libboost-iostreams-dev ruby-full

COPY . /
WORKDIR /

RUN gem install glug && \
    gem install cgi && \
    gem install rack && \
    make && \
    make install && \
    # clean up, remove build-time only dependencies
    rm -rf /var/lib/apt/lists/* && \
    apt-get purge -y --auto-remove build-essential liblua5.1-0-dev

ENTRYPOINT ["tilemaker"]
