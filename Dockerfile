FROM nginx:alpine

ENV BACKEND_UPSTREAM_URL=http://hpnmobilebackend.railway.internal:4000

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Clear bundled html so only our staged builds remain
RUN rm -rf /usr/share/nginx/html/*

# Copy templated config so the backend upstream can be injected at startup
COPY nginx.conf.template /etc/nginx/templates/default.conf.template
COPY docker-entrypoint.d/10-render-config.sh /docker-entrypoint.d/10-render-config.sh
RUN chmod +x /docker-entrypoint.d/10-render-config.sh

# Copy public web app at /
COPY web-dist/ /usr/share/nginx/html/

# Copy admin app at /admin/
COPY admin-dist/ /usr/share/nginx/html/admin/
