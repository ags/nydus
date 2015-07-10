FROM haskell:7.10

RUN cabal update

ADD nydus.cabal /src/

WORKDIR /src

RUN cabal install --only-dependencies --enable-tests

ADD . /src
