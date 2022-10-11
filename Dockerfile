FROM ubuntu:22.04
EXPOSE 8080/tcp

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    curl make cmake gcc g++ ruby-dev python3-pydot graphviz

# Install bundler
RUN gem install bundler

# Install Kaitai
RUN curl -LO https://github.com/kaitai-io/kaitai_struct_compiler/releases/download/0.10/kaitai-struct-compiler_0.10_all.deb
RUN apt-get install -y ./kaitai-struct-compiler_0.10_all.deb

COPY . .

# Build the spec
RUN bundle install
RUN make

RUN mv polkadot-spec.html index.html

RUN echo "echo 'Expose port 8080 and open it in the browser!'" >> startup.sh
run echo "python3 -m http.server 8080" >> startup.sh

ENTRYPOINT ["/bin/bash", "startup.sh"]
