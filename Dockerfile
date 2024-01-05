# Step 1
FROM node:20.10 as build

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build


# Step 2
FROM nginx:latest

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /app/dist/my-docker-angular-app /usr/share/nginx/html/

RUN chown nginx:nginx /usr/share/nginx/html/browser/*

RUN chmod +x /usr/share/nginx/html/*

COPY  custom.conf /etc/nginx/conf.d/custom.conf

RUN ls -l /usr/share/nginx/html/server && \ 
    ls -l /usr/share/nginx/html/browser && \ 
    find /usr/share/nginx/html/server -type f -exec stat {} \; && \ 
    find /usr/share/nginx/html/browser -type f -exec stat {} \;

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]