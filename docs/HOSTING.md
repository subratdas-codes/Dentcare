# DentCare hosting: permanent, always-on options

DentCare is a **Java 17 + Spring Boot + JSP** application. That is why the
Vercel setup used for a static React frontend does not transfer directly.

Vercel's normal runtimes cannot serve JSP. Vercel's **Container Runtime** can
run the Docker image, but it is still a Function: it scales down after about
five minutes without traffic, has an ephemeral filesystem, and has a 4.5 MB
request/response limit. A 5 MB doctor photo would be rejected, and a cold start
would still exist. It is not a permanent always-on host for this app.

Use one of the options below instead.

| Option | Cost | Always on? | Effort |
|---|---|---|---|
| **Koyeb Free + Neon** | $0 | Kept awake by DentCare's built-in ping; short wake-up if the ping ever fails | Easy |
| **Oracle Cloud Always Free + Docker** | $0 | Yes, the VM runs continuously | Medium |
| **Render Starter + Neon** | ~$7/month | Yes | Easiest |
| Render Free + built-in ping | $0 | Usually, but shares Render's 750 free hours with any other free service (including AimRoute's backend) | Easy, not guaranteed |

For a free deployment that does not touch AimRoute and has no monthly Render
hour quota, use **Koyeb Free + Neon**. For a hard always-on guarantee with no
PaaS sleep behaviour at all, use **Oracle Cloud Always Free**.

---

## Option 1: Koyeb Free + Neon (recommended free option)

Koyeb's free web instance gives one service with 512 MB RAM, 0.1 vCPU and 2 GB
of disk. It scales to zero after **one hour** without traffic. DentCare's
built-in keep-alive sends a health request every 10 minutes, so the service
stays warm. If Koyeb ever restarts it, the wake-up is much shorter than
Render's 60–75 seconds.

Koyeb's free instance has no persistent volume. Doctor photos are now stored in
PostgreSQL (the `doctor_photos` table), so they survive redeploys. Legacy files
under `/uploads/doctors/` do not; see [Doctor photos](#doctor-photos) below.

### 1. Create the free database (Neon)

1. Sign in at <https://neon.tech> and create a project in a region close to you
   (for India, Singapore or Frankfurt).
2. Create a database named `dentcare`.
3. Open **Connect** and copy the **pooled** connection string. It looks like:
   `postgresql://user:password@ep-xxx-pooler.region.aws.neon.tech/dentcare?sslmode=require`
4. Convert it to a JDBC URL by replacing `postgresql://` with
   `jdbc:postgresql://` and removing the username/password from the URL:
   `jdbc:postgresql://ep-xxx-pooler.region.aws.neon.tech/dentcare?sslmode=require`
5. Keep the username and password for the environment variables below.

Neon's free database does not expire after 30 days.

### 2. Create the Koyeb service

1. Sign in at <https://app.koyeb.com> with GitHub.
2. **Create Service → GitHub**, choose `subratdas-codes/Dentcare`, branch `main`.
3. Builder: **Dockerfile**. Dockerfile path: `Dockerfile`.
4. Instance: **Free**. Region: **Frankfurt** (or Washington, D.C.).
5. Port: **8000** (Koyeb sets `PORT=8000`; the app already reads `PORT`).
6. Health check: HTTP, path `/actuator/health`.
7. Add these environment variables:

   | Variable | Value |
   |---|---|
   | `SPRING_PROFILES_ACTIVE` | `prod` |
   | `DB_URL` | `jdbc:postgresql://ep-xxx-pooler.../dentcare?sslmode=require` |
   | `DB_USER` | Neon username |
   | `DB_PASSWORD` | Neon password |
   | `APP_URL` | `https://<your-service>.koyeb.app` |
   | `APP_KEEPALIVE_ENABLED` | `true` |
   | `APP_KEEPALIVE_URL` | `https://<your-service>.koyeb.app` |
   | `SMTP_HOST` | e.g. `smtp-relay.brevo.com` |
   | `MAIL_USERNAME` | SMTP login |
   | `MAIL_PASSWORD` | SMTP key |

   `APP_URL` is used in password-reset links. Set it after Koyeb shows the
   service URL, then redeploy once.

8. Deploy. Wait for the health check to pass, then open the service URL.

The built-in keep-alive starts two minutes after boot and pings every ten
minutes. It logs `Keep-alive enabled; pinging ...` at startup. No GitHub
Actions cron is needed.

### 3. Move the existing Render data to Neon

Do this **before** the Render free database expires. Use the external database
URL from **Render Dashboard → dentcare-db → Connect**.

On a machine with PostgreSQL client tools (or in a temporary GitHub Actions
job):

```bash
export RENDER_DB_URL='postgresql://...'
export NEON_DB_URL='postgresql://...'

pg_dump --no-owner --no-privileges --format=custom \
  --file=dentcare.dump "$RENDER_DB_URL"

pg_restore --no-owner --no-privileges --clean --if-exists \
  --dbname="$NEON_DB_URL" dentcare.dump
```

Then verify the important tables:

```bash
psql "$NEON_DB_URL" -c "select count(*) from doctors;"
psql "$NEON_DB_URL" -c "select count(*) from patients;"
psql "$NEON_DB_URL" -c "select count(*) from appointments;"
```

Take the dump during a quiet period and switch `DB_URL` immediately afterward.
Any booking made between the dump and the switch would otherwise be missing.

---

## Option 2: Oracle Cloud Always Free + Docker (true always-on)

Oracle's Always Free Ampere A1 allowance is currently 2 OCPU and 12 GB RAM
(Oracle reduced it from 4 OCPU / 24 GB in June 2026). A single small VM is more
than enough for DentCare. The VM runs continuously; there is no PaaS sleep.

This repository now includes a complete `docker-compose.yml` with:
- DentCare (the Spring Boot/JSP app)
- PostgreSQL 16 with a persistent volume
- Caddy with automatic HTTPS

### 1. Create the VM

1. Create an Oracle Cloud account and choose an **Always Free** Ampere A1
   instance, Ubuntu 22.04, with a public IPv4 address.
2. Open ingress for TCP **80** and **443** in the VCN security list.
3. On the VM, allow the ports:
   ```bash
   sudo ufw allow 80/tcp
   sudo ufw allow 443/tcp
   ```

### 2. Point a free domain at it

Create a free subdomain at <https://www.duckdns.org>, for example
`carebydent.duckdns.org`, and point it at the VM's public IP. Caddy will obtain
a Let's Encrypt certificate automatically.

### 3. Install Docker and start DentCare

```bash
sudo apt update
sudo apt install -y docker.io docker-compose-v2 git
sudo usermod -aG docker "$USER"
# log out and back in so the docker group applies

git clone https://github.com/subratdas-codes/Dentcare.git
cd Dentcare
cp .env.example .env
nano .env       # set DOMAIN and a strong POSTGRES_PASSWORD
docker compose up -d --build
```

Check it:

```bash
docker compose ps
docker compose logs -f app
curl -fsS https://carebydent.duckdns.org/actuator/health
```

The database and uploads live in Docker volumes, so `docker compose down` and
redeploys do not lose data.

### 4. Backups

Run a nightly dump from the VM's crontab:

```bash
mkdir -p ~/dentcare-backups
0 2 * * * cd /home/ubuntu/Dentcare && docker compose exec -T db \
  pg_dump -U dentcare dentcare | gzip > ~/dentcare-backups/dentcare-$(date +\%F).sql.gz
```

Copy the backups off the VM periodically.

### 5. Updates

```bash
cd ~/Dentcare
git pull
docker compose up -d --build
```

Oracle may reclaim Always Free compute instances that are completely idle for
seven days. A live clinic site with normal traffic is not idle, but if the site
will be unused for long periods, keep a small external uptime monitor on it.

---

## Option 3: Render Starter + Neon (easiest paid option)

This keeps the current `carebydent.onrender.com` URL and removes the sleep.

1. In **Render Dashboard → carebydent → Settings**, change the instance type
   from **Free** to **Starter** (~$7/month) and add a payment method.
2. Create the Neon database as described above.
3. Add `DB_URL`, `DB_USER` and `DB_PASSWORD` to the Render service's
   environment variables and redeploy.
4. Leave `APP_KEEPALIVE_ENABLED` unset (or `false`); a paid instance never
   sleeps.
5. Delete or let expire the Render free PostgreSQL database only after the
   Neon migration has been verified.

A paid web service does not consume the 750 free instance hours, so it will not
affect AimRoute's free backend.

---

## Render Free + built-in ping (not recommended for a guarantee)

If you want to stay on Render Free for now, add these environment variables to
the Render service:

| Variable | Value |
|---|---|
| `APP_KEEPALIVE_ENABLED` | `true` |

On Render, `RENDER_EXTERNAL_URL` is set automatically, so the app pings its own
`/actuator/health` every ten minutes after a two-minute initial delay. This
keeps the service warm without GitHub Actions.

Important limit: Render gives **750 free instance hours per workspace per
month**, shared by every free service in that workspace. Keeping DentCare awake
24/7 uses roughly 730 of those hours. If AimRoute's backend is in the same
workspace and also runs for more than about 20 hours that month, Render can
suspend both services until the next month. That is why this is a workaround,
not a guarantee. Koyeb Free does not have this monthly hour cap.

The Render free PostgreSQL database still expires 30 days after creation. Move
it to Neon as described above regardless of which web host you use.

---

## Doctor photos

New doctor photos are stored in the `doctor_photos` PostgreSQL table and served
from `/doctor-photo/<uuid>.jpg|png`. This works on Render, Koyeb, Vercel
containers, and Oracle because the database is persistent.

Old photos under `/uploads/doctors/` are still served from local disk for
backward compatibility. If you migrate hosts, download the old files from the
current site first:

```bash
curl -O https://carebydent.onrender.com/uploads/doctors/<file>.jpg
```

or re-upload them from **Admin → Profile** / **Doctor → Profile** after the
migration.

---

## After switching hosts: verification checklist

- [ ] `GET /actuator/health` returns `{"status":"UP"}`
- [ ] Home page, About, Service, Team, Price, Contact load
- [ ] Patient registration and patient login (`/login`) work
- [ ] Staff chooser (`/portal`) shows only Doctor and Admin
- [ ] Doctor login and dashboard work
- [ ] Admin login and dashboard work
- [ ] Booking an appointment works
- [ ] Receipt/PDF download works
- [ ] Forgot-password and reset-password emails work
- [ ] Doctor photo upload works and the image survives a redeploy
- [ ] Mobile hamburger menu opens and all links are readable
- [ ] Log in, restart the service, and confirm the session behaviour is expected
