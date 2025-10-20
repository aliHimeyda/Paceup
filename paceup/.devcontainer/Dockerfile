# Flutter ortamını baz al
FROM flutter-dev:latest

# Node.js 20 + Firebase CLI kur
RUN apt-get update && apt-get install -y curl ca-certificates gnupg && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
      | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" \
      > /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && apt-get install -y nodejs && \
    npm install -g firebase-tools && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
CMD ["bash"]
