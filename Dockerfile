# Dockerfile

# Step 1: Build the React app
FROM node:18-alpine AS build

WORKDIR /app

# Copy the package.json and pnpm-lock.yaml files
COPY package.json pnpm-lock.yaml ./

# Install pnpm
RUN npm install -g pnpm

# Install dependencies
RUN pnpm install

# Copy the entire project
COPY . .

# Build the project
RUN pnpm run build

# Step 2: Serve the app with Nginx
FROM nginx:stable-alpine

# Copy the build files from the previous step
COPY --from=build /app/dist /usr/share/nginx/html

# 기본 nginx 설정 파일을 삭제한다. (custom 설정과 충돌 방지)
RUN rm /etc/nginx/conf.d/default.conf

# custom 설정파일을 컨테이너 내부로 복사한다.
COPY nginx/nginx.conf /etc/nginx/conf.d

# 컨테이너의 80번 포트를 열어준다.
EXPOSE 80


# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

# # Dockerfile 예시
# # Step 1: Build the React app
# FROM node:18-alpine AS build
# 
# WORKDIR /app
# 
# # Copy the package.json and pnpm-lock.yaml files
# COPY package.json pnpm-lock.yaml ./
# 
# # Install pnpm
# RUN npm install -g pnpm
# 
# # Install dependencies
# RUN pnpm install
# 
# # Copy the entire project
# COPY . .
# 
# # Build the project
# RUN pnpm run build
# 
# # Step 2: Serve the app with Nginx
# FROM nginx:stable-alpine
# 
# # Copy the build files from the previous step
# COPY --from=build /app/dist /usr/share/nginx/html
# 
# # 기본 nginx 설정 파일을 삭제한다. (custom 설정과 충돌 방지)
# RUN rm /etc/nginx/conf.d/default.conf
# 
# # custom 설정파일을 컨테이너 내부로 복사한다.
# COPY nginx/nginx.conf /etc/nginx/conf.d
# 
# # 컨테이너의 80번 포트를 열어준다.
# EXPOSE 80
# 
# # Step 3: Set up the entry point to substitute the environment variable into the Nginx config
# CMD ["/bin/sh", "-c", "envsubst '$$UPSTREAM_APP' < /etc/nginx/nginx.conf > /etc/nginx/nginx.conf && nginx -g 'daemon off;'"]
# 