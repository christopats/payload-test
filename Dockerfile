# This template uses Automatically Copying Traced Files feature
# so you need to setup your Next Config file to use `output: 'standalone'`
# Please read this for more information https://nextjs.org/docs/pages/api-reference/next-config-js/output

# Production image, copy all the files and run next
FROM docker.io/node:slim AS runner
RUN apk add --no-cache dumb-init

ENV NODE_ENV=production
ENV SECRET_ENV=/secrets/env
ENV PORT=8080
ENV NEXT_TELEMETRY_DISABLED=1
WORKDIR /usr/src/app
RUN npm install --ignore-scripts=false --foreground-scripts --verbose sharp
COPY payload-test.db ./
COPY next.config.js ./
COPY public ./public
COPY .next/standalone ./
COPY .next/standalone/package.json ./
COPY .next/standalone/node_modules ./node_modules
COPY .next/static ./.next/static
# RUN npm i sharp
RUN chown -R node:node .
USER node
EXPOSE 8080
# COPY --chown=node:node ./tools/scripts/entrypoints/api.sh /usr/local/bin/docker-entrypoint.sh
# ENTRYPOINT [ "docker-entrypoint.sh" ]
# Next.js collects completely anonymous telemetry data about general usage.
# Learn more here: https://nextjs.org/telemetry
# Uncomment the following line in case you want to disable telemetry.
CMD ["sh", "-c", "dumb-init node --env-file=${SECRET_ENV} server.js"]
