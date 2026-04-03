FROM nginx:alpine

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
