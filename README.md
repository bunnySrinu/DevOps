# ⚙️ DevOps

A small, working example of a **Docker + CI/CD pipeline**: a static site containerized with a multi-stage Dockerfile, run through an automated GitHub Actions workflow that lints, builds, health-checks, and pushes the image to Docker Hub.

<p align="left">
  <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" />
  <img src="https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white" />
  <img src="https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white" />
</p>

---

## 📖 What's in here

| File | Purpose |
|---|---|
| `Dockerfile` | Multi-stage build → lightweight Nginx runtime image, runs as non-root, has a built-in `HEALTHCHECK` |
| `docker-compose.yml` | One-command local run (`docker compose up`) with health checks |
| `nginx/default.conf` | Custom Nginx config, including a `/healthz` endpoint used by CI and the container health check |
| `.github/workflows/ci-cd.yml` | CI/CD pipeline: lint → build → health-check → push to Docker Hub |
| `src/index.html` | The static site being served (swap this for a real app anytime) |

## 🔁 What the pipeline does

1. **Lint** — `Dockerfile` is checked with [Hadolint](https://github.com/hadolint/hadolint) for best-practice issues.
2. **Build & test** — the image is built, run, and polled on `/healthz` until it responds, proving the container actually works before anything ships.
3. **Push** — on a push to `main`, the image is tagged with both `latest` and the commit SHA and pushed to Docker Hub.

This mirrors a real-world pattern: nothing gets pushed unless it lints clean and passes a live health check.

## 🚀 Run it locally

```bash
git clone https://github.com/bunnySrinu/DevOps.git
cd DevOps
docker compose up --build
```

Visit `http://localhost:8080` — you should see the demo page. Check `http://localhost:8080/healthz` for the health endpoint.

## 🔐 Setting up the push step (optional)

To let the pipeline push to your own Docker Hub account, add these as **repo secrets** (Settings → Secrets and variables → Actions):

- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN` (a Docker Hub access token, not your password)

Without these, the `lint` and `build-and-test` jobs still run fine on every push/PR — only the final `push` job needs them.

## 🗺️ Roadmap

- [ ] Swap the static site for a real backend app
- [ ] Add a staging/production deploy step (e.g. to a VPS or Kubernetes)
- [ ] Add Terraform for provisioning the target infrastructure
- [ ] Add automated rollback on failed health check
