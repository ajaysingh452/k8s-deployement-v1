# Welcome Web Deployment

This project provides a simple static website deployment using Docker, Kubernetes, and NGINX, with automated deployment scripts and ingress configuration for cloud-native environments.

## Project Structure

```
welcome-web-deployment/
  deploy/
    .env                # Environment variables for deployment
    deploy.sh           # Deployment script (builds Docker image & applies K8s manifests)
    Dockerfile          # Dockerfile for building the NGINX static site image
    welcome-web/
      index.html        # Main static HTML page
```

## Features

- **Static Website**: The site is built with HTML and styled using Tailwind CSS.
- **Dockerized**: Uses NGINX to serve static content.
- **Kubernetes Ready**: Automated deployment to Kubernetes with Service and Ingress.
- **Ingress Support**: Easily expose your site via an Ingress controller (e.g., NGINX Ingress).
- **Configurable**: Deployment parameters (namespace, app name, ingress host/path) are customizable via `.env` or prompts.

## Prerequisites

- [Docker](https://www.docker.com/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- Access to a Kubernetes cluster with [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/) installed

## Quick Start

1. **Clone the repository**

   ```sh
   git clone <your-repo-url>
   cd welcome-web-deployment/deploy
   ```

2. **Configure Environment Variables**

   Edit `.env` to set your desired namespace, app name, ingress host, and path:

   ```
   NAMESPACE=apps
   APP_NAME=welcome-web
   INGRESS_HOST=inichepro.in
   INGRESS_PATH=hi
   ```

3. **Deploy to Kubernetes**

   Run the deployment script:

   ```sh
   ./deploy.sh
   ```

   The script will:
   - Build the Docker image
   - Deploy the Deployment, Service, and Ingress resources to your cluster

4. **Access the Website**

   - The site will be available at `http://<INGRESS_HOST>/<INGRESS_PATH>` (e.g., `http://inichepro.in/hi`)
   - Ensure your DNS and ingress controller are configured to route traffic to your cluster.

## File Overview

- [`deploy.sh`](welcome-web-deployment/deploy/deploy.sh): Automates Docker build and Kubernetes deployment.
- [`Dockerfile`](welcome-web-deployment/deploy/Dockerfile): Builds an NGINX image serving the static site.
- [`welcome-web/index.html`](welcome-web-deployment/deploy/welcome-web/index.html): Main HTML file for the site.
- [`.env`](welcome-web-deployment/deploy/.env): Deployment configuration.

## Customization

- Edit `welcome-web/index.html` to change the website content.
- Update `.env` or provide values at runtime to customize deployment parameters.

## License

MIT License

---

**Note:** For production, consider using a container registry for your Docker image and securing your ingress with