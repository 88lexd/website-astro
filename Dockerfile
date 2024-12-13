# Build layer
FROM node:18 AS builder

RUN npm install -g pnpm@latest-7

COPY . /app

WORKDIR /app/astro

RUN pnpm install && \
    pnpm build


# Production
FROM nginx:alpine

COPY --from=builder /app/astro/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
