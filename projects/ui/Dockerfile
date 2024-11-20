FROM node:20.13-bullseye-slim AS base
RUN addgroup --gid 2000 --system appgroup && \
        adduser --uid 2000 --system appuser --gid 2000

WORKDIR /app
COPY package*.json ./
FROM base AS build
COPY . .
RUN npm run build

FROM base

COPY --from=build --chown=appuser:appgroup \
        /app/package.json \
        /app/package-lock.json \
        /app/tsconfig.json \
        ./

#COPY --from=build --chown=appuser:appgroup \
#        /app/assets ./assets

COPY --from=build --chown=appuser:appgroup \
        /app/src ./src

COPY --from=build --chown=appuser:appgroup \
        /app/node_modules ./node_modules

EXPOSE 3000
CMD ["npm", "run", "start"]
