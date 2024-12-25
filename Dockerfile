# syntax=docker/dockerfile:1-labs

FROM node:18 AS builder

WORKDIR /app/astro

RUN npm install -g pnpm@latest-7

# Must exclude these directory on initial copy, not sure why but is failing the `pnpm build`..
COPY --exclude=astro/src --exclude=astro/public . /app
RUN pnpm install

# Copy remaining files before build
COPY astro/src /app/astro/src
COPY astro/public /app/astro/public

RUN pnpm build


# Production
FROM nginx:alpine

COPY --from=builder /app/astro/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# This file should be created as part of the CI workflow
COPY version.txt /app/version.txt

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
