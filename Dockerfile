# Sử dụng image Node.js Alpine làm base image (nhẹ, tối ưu cho production)
FROM node:18-alpine

# Thiết lập thư mục làm việc trong container
WORKDIR /app

# Sao chép package.json và package-lock.json để cài đặt dependencies
COPY package*.json ./

# Cài đặt dependencies (chỉ production để giảm kích thước image)
RUN npm install --only=production

# Sao chép toàn bộ mã nguồn ứng dụng vào container
COPY . .

# Build ứng dụng nếu cần (nếu bạn có script build, ví dụ: React, Vue)
# RUN npm run build

# Mở port mà ứng dụng sẽ chạy
EXPOSE 3000

# Lệnh khởi động ứng dụng
CMD ["npm", "start"]
