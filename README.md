# DevClef — Zola static site

This repository contains a minimal [Zola](https://www.getzola.org/) site with a multi-stage Dockerfile that builds the site and serves it via Nginx.

## Prerequisites
- Docker 20.10+

## Local development (without Docker)
If you have Zola installed locally:

```
zola serve
```

Then open http://127.0.0.1:1111

## Build and run with Docker
Build the image:

```
docker build -t devclef-site:latest .
```

Run the container:

```
docker run --rm -p 8080:80 devclef-site:latest
```

Open http://localhost:8080

## Configuration
Edit `config.toml` and set a proper `base_url` for production, e.g.

```
base_url = "https://devclef.example.com"
```

## Project structure
- `content/` — your Markdown content
- `templates/` — site templates (Tera)
- `static/` — static assets (served as-is)
- `config.toml` — Zola configuration
- `Dockerfile` — build-and-serve container image
- `.dockerignore` — ignores for Docker context

## Reference
- Zola Docker image docs: https://www.getzola.org/documentation/deployment/docker-image/

## CI: Build and publish Docker image (GitHub Actions)
This repo includes a GitHub Actions workflow that builds and publishes a Docker image on pushes to `main`/`master` and when pushing tags like `v1.2.3`.

Workflow: `.github/workflows/docker-publish.yml`

It publishes to GitHub Container Registry (GHCR) by default using the repository path:

```
ghcr.io/<owner>/<repo>:<tag>
```

Enabling pushes to GHCR:
- Nothing to configure: Actions uses `${{ secrets.GITHUB_TOKEN }}` with `packages: write` permissions.

Optional: Also publish to Docker Hub
- Add repository secrets:
  - `DOCKERHUB_USERNAME`
  - `DOCKERHUB_TOKEN` (Docker Hub access token)
- The workflow will then push tags to:
  - `docker.io/<DOCKERHUB_USERNAME>/<repo>:<tag>`

Tags generated automatically (via docker/metadata-action):
- `latest` on the default branch
- Branch name on branch builds
- `vX.Y.Z` (and semver variants) on tagged builds
- Image digest `sha-<shortsha>`

Example pull/run (GHCR):

```
docker pull ghcr.io/<owner>/<repo>:latest
docker run --rm -p 8080:80 ghcr.io/<owner>/<repo>:latest
```
