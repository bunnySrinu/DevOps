# ---- Build stage ----
FROM alpine:3.20 AS build
WORKDIR /app
COPY src/ ./src/

# (Placeholder for a real build step, e.g. npm run build)
# Keeps the pattern realistic for when this becomes a real app.
RUN mkdir -p /app/dist && cp -r src/* /app/dist/

# ---- Runtime stage ----
FROM nginx:1.27-alpine AS runtime

# Run as non-root for better security posture
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

RUN chown -R appuser:appgroup /usr/share/nginx/html && \
    chown -R appuser:appgroup /var/cache/nginx && \
    chown -R appuser:appgroup /var/log/nginx && \
    touch /var/run/nginx.pid && \
    chown -R appuser:appgroup /var/run/nginx.pid

USER appuser

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -qO- http://localhost:80/healthz || exit 1

CMD ["nginx", "-g", "daemon off;"]
