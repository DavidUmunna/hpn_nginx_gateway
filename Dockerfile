FROM nginx:alpine

ENV BACKEND_UPSTREAM_URL=http://hpnmobilebackend.railway.internal:4000

# Opt into the base image's own docker-entrypoint.d/15-local-resolvers.envsh,
# which exports NGINX_LOCAL_RESOLVERS from /etc/resolv.conf (bracket-wrapping
# IPv6 addresses correctly). Used in nginx.conf.template's `resolver`
# directive so the gateway re-resolves the backend's address periodically
# instead of caching whatever it got at startup — otherwise a backend
# redeploy (new internal IP) silently breaks the gateway until it's
# restarted. It's sourced (not executed), so — unlike a plain .sh script —
# its export actually persists to the later envsubst step that reads it.
ENV NGINX_ENTRYPOINT_LOCAL_RESOLVERS=1

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Clear bundled html so only our staged builds remain
RUN rm -rf /usr/share/nginx/html/*

# Copy templated config so the backend upstream can be injected at startup
COPY nginx.conf.template /etc/nginx/templates/default.conf.template

# Copy public web app at /
COPY web-dist/ /usr/share/nginx/html/

# Copy admin app at /admin/
COPY admin-dist/ /usr/share/nginx/html/admin/
