FROM node:18-slim as BASE

RUN npm i -g @soos-io/soos-sca

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]