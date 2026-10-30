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
(Oracle reduced it from 4 OCPU / 24 GB in June 2026). This is a real Linux VM
that runs 24/7: no sleep, no cold start, and no monthly instance-hour quota.

The repository includes everything needed:

- `Dockerfile` — builds DentCare
- `docker-compose.yml` — DentCare + PostgreSQL 16 + Caddy
- `Caddyfile` — automatic HTTPS
- `.env.example` — settings template

You need an Oracle Cloud account (a card is used for identity verification;
Always Free resources are not charged), a free DuckDNS account, and an SSH key.

### 1. Create the VM

1. Sign in at <https://cloud.oracle.com> and pick a **home region** close to
   your patients (for India, Mumbai or Hyderabad). The home region cannot be
   changed later.
2. **Menu → Compute → Instances → Create instance**.
3. Name: `dentcare`.
4. **Image and shape → Change image**: Canonical Ubuntu 22.04 (or 24.04).
5. **Shape**: Ampere → `VM.Standard.A1.Flex`, **2 OCPUs**, **12 GB memory**
   (the full Always Free allowance). If Oracle reports no capacity, try the
   other availability domain, or retry later.
6. **Networking**: create a new VCN with a public subnet and make sure
   **Assign a public IPv4 address** is selected.
7. **Add SSH keys**: choose **Generate a key pair** and download the private
   key, or paste your own public key.
8. Boot volume: 50 GB is enough (Always Free includes 200 GB total).
9. Create the instance and wait until it is **Running**. Copy the **Public IP
   address**.

On Windows, create a key and connect (PowerShell):

```powershell
ssh-keygen -t ed25519 -f "$env:USERPROFILE\.ssh\dentcare"
Get-Content "$env:USERPROFILE\.ssh\dentcare.pub"
```

Paste the printed public key into Oracle's SSH key box. Then connect:

```powershell
ssh -i "$env:USERPROFILE\.ssh\dentcare" ubuntu@<PUBLIC_IP>
```

### 2. Open ports 80 and 443 (two firewalls)

Oracle has a network firewall (security list) and Ubuntu has its own firewall.
Both must allow the ports.

**Oracle console:** VCN → Security Lists → Default Security List → Add Ingress
Rules:

- Source `0.0.0.0/0`, protocol TCP, destination port `80`
- Source `0.0.0.0/0`, protocol TCP, destination port `443`

**On the VM:**

```bash
sudo apt-get update
sudo apt-get install -y iptables-persistent
sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 443 -j ACCEPT
sudo netfilter-persistent save
```

Check that the ACCEPT rules are above the REJECT rule:

```bash
sudo iptables -L INPUT -n --line-numbers
```

### 3. Point a free domain at the VM

1. Sign in at <https://www.duckdns.org>.
2. Create a subdomain, for example `carebydent`, and set its IP to the VM's
   public IP. The full name is `carebydent.duckdns.org`.
3. Recommended: keep the IP updated automatically, because an ephemeral Oracle
   IP can change if the instance is stopped and started. Create
   `~/duckdns.sh`:

   ```bash
   #!/usr/bin/env bash
   curl -fsS "https://www.duckdns.org/update?domains=carebydent&token=YOUR_TOKEN&ip=" >/dev/null
   ```

   ```bash
   chmod +x ~/duckdns.sh
   (crontab -l 2>/dev/null; echo "*/5 * * * * $HOME/duckdns.sh") | crontab -
   ```

### 4. Install Docker

```bash
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker "$USER"
```

Log out and back in (or run `newgrp docker`) so the group change applies.

```bash
docker --version
docker compose version
```

### 5. Get DentCare and configure it

```bash
git clone https://github.com/subratdas-codes/Dentcare.git
cd Dentcare
cp .env.example .env
nano .env
```

Set at least:

```dotenv
DOMAIN=carebydent.duckdns.org
POSTGRES_PASSWORD=<run: openssl rand -hex 24>
SMTP_HOST=smtp-relay.brevo.com
SMTP_PORT=587
MAIL_USERNAME=<your SMTP login>
MAIL_PASSWORD=<your SMTP key>
```

Use the same SMTP values that already work on Render. Without them DentCare
still runs, but password-reset emails are only written to the log and never
delivered. `DOMAIN` must be the DuckDNS name **without** `https://`.

### 6. Move the existing Render database

The current clinic data lives in Render's free PostgreSQL. Render deletes that
database 30 days after creation, so migrate it now — **before starting the app
for the first time on this VM**.

1. Open **Render Dashboard → dentcare-db → Connect** and copy the **External
   Database URL**.
2. On the VM, start only the database:

   ```bash
   docker compose up -d db
   ```

3. Dump Render into a file. `read -s` hides the URL from the screen and from
   shell history:

   ```bash
   read -rsp "Paste the Render External Database URL: " RENDER_DB_URL; echo
   docker run --rm -e RENDER_DB_URL="$RENDER_DB_URL" postgres:16-alpine \
     sh -c 'pg_dump --no-owner --no-privileges -Fc "$RENDER_DB_URL"' \
     > ~/dentcare.dump
   ls -lh ~/dentcare.dump
   ```

4. Restore into the new local database:

   ```bash
   docker compose exec -T db pg_restore --no-owner --no-privileges \
     --clean --if-exists -U dentcare -d dentcare < ~/dentcare.dump
   ```

5. Verify the important tables:

   ```bash
   docker compose exec -T db psql -U dentcare -d dentcare \
     -c "select count(*) from doctors;" \
     -c "select count(*) from patients;" \
     -c "select count(*) from appointments;"
   ```

Do not start the app before the restore. On an empty database Hibernate creates
the tables and a default admin account; restoring is cleanest before that. If
the app is already running, stop it first with `docker compose stop app`.

### 7. Start DentCare

```bash
docker compose up -d --build
docker compose ps
docker compose logs -f app
```

The first build takes a few minutes. Wait until `app` is `healthy` and `caddy`
is `running`, then open `https://carebydent.duckdns.org`.

Caddy obtains the HTTPS certificate automatically on the first request. If it
does not, check that DuckDNS points to the VM and that both firewalls allow
ports 80 and 443.

### 8. Backups

Create a backup script:

```bash
mkdir -p ~/dentcare-backups
cat > ~/backup-dentcare.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/Dentcare"
docker compose exec -T db pg_dump -U dentcare -d dentcare \
  | gzip > "$HOME/dentcare-backups/dentcare-$(date +%F).sql.gz"
find "$HOME/dentcare-backups" -name '*.sql.gz' -mtime +14 -delete
EOF
chmod +x ~/backup-dentcare.sh
(crontab -l 2>/dev/null; echo "0 2 * * * $HOME/backup-dentcare.sh") | crontab -
```

Copy backups off the VM regularly, for example from Windows:

```powershell
scp -i "$env:USERPROFILE\.ssh\dentcare" `
  ubuntu@<PUBLIC_IP>:~/dentcare-backups/*.sql.gz .
```

To restore a backup, stop the app, recreate the database, and load the dump:

```bash
docker compose stop app
docker compose exec -T db dropdb -U dentcare --force dentcare
docker compose exec -T db createdb -U dentcare dentcare
gunzip -c ~/dentcare-backups/dentcare-YYYY-MM-DD.sql.gz \
  | docker compose exec -T db psql -U dentcare -d dentcare
docker compose start app
```

### 9. Updates

```bash
cd ~/Dentcare
git pull
docker compose up -d --build
```

The database and uploads live in Docker volumes, so rebuilding does not lose
data. Expect users to be logged out during the restart.

Oracle may reclaim Always Free compute instances that are completely idle for
seven days. A live clinic site is not idle. To be safe, add a free
<https://uptimerobot.com> HTTP monitor for
`https://carebydent.duckdns.org/actuator/health` every 5 minutes; it also emails
you if the site goes down.

Keep `.env` private — it contains the database and SMTP passwords. It is already
listed in `.gitignore`.

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
