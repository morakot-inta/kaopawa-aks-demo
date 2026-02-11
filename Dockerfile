FROM node:lts-alpine as builder
ENV NODE_ENV=production
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN npm install --production --silent && mv node_modules ../
COPY . .
RUN npm install -g typescript
RUN npm run build

FROM nginx:alpine
COPY --from=builder /usr/src/node_modules /usr/src/node_modules
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html
EXPOSE 80 
