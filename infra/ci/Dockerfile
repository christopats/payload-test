FROM gcr.io/gcp-runtimes/ubuntu_20_0_4

COPY --from=gcr.io/cloud-sql-connectors/cloud-sql-proxy /cloud-sql-proxy /cloudsql/cloud-sql-proxy

ENV NODE_VERSION=22.12.0
RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version
RUN npm install -g pnpm firebase-tools
RUN pnpm --version
RUN firebase --version

ENTRYPOINT ["bash"]
