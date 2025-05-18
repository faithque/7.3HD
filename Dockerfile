# Use an official Node.js runtime as a parent image
FROM node:18-alpine AS builder

# Set the working directory in the container
WORKDIR /project

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install application dependencies
RUN npm install --production

# Copy the rest of the application code to the working directory
COPY . .

# --- Final image for running the application ---
FROM node:18-alpine

# Set the working directory
WORKDIR /project

# Copy only the necessary files from the builder stage
COPY --from=builder /project/node_modules ./node_modules
COPY --from=builder /project/. .
# COPY --from=builder /app/build ./ # If you have a build step

# Expose the port your Express app listens on (default is often 3000)
EXPOSE 3000

# Define environment variables for database connection
# It's generally better to pass these during container runtime for security
# ENV DB_HOST=your_db_host
# ENV DB_USER=your_db_user
# ENV DB_PASSWORD=your_db_password
# ENV DB_NAME=your_db_name

# Command to start your Node.js application
CMD [ "npm", "start" ]