FROM node:18-slim as BASE

RUN npm i -g @soos-io/soos-sbom
# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
COPY check_version.py /check_version.py

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]