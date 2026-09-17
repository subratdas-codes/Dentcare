# Dentcare - Doctor Clinic Management App

A full-stack web application for managing a dental clinic — appointment scheduling, patient registration, doctor profiles, and admin operations.

**Live:** [https://carebydent.onrender.com](https://carebydent.onrender.com)

---

## Tech Stack

| Layer       | Technology                                      |
|-------------|-------------------------------------------------|
| Backend     | Java 17 · Spring Boot 3.1 · Spring Security 6  |
| Views       | JSP + JSTL + Spring Security Taglibs            |
| Frontend    | Bootstrap 5 · Font Awesome · Custom CSS         |
| Persistence | Spring Data JPA · Hibernate 6                    |
| Local DB    | MySQL 8 / H2 (zero-config profile)              |
| Prod DB     | PostgreSQL (Render Free Managed)                 |
| Build       | Maven (wrapper included)                        |
| Deploy      | Docker · Render.com (free)                      |
| CI          | GitHub Actions                                   |

---

## Features

- **Patient portal** — register, login, book/view appointments, change password, profile
- **Admin portal** — dashboard stats, manage doctors, view patients, manage appointments
- **Role-based access** — Spring Security with `ROLE_USER` (patient) and `ROLE_ADMIN`
- **Zero-config local run** — H2 in-memory DB (`--spring.profiles.active=local`)
- **Production ready** — PostgreSQL via Render managed DB, no secrets committed

---

## Architecture

```
Browser
  │
  ▼
┌──────────────────────────────────────────┐
│  Spring Security Filter Chain            │
│  (authentication, CSRF, role guards)     │
└────────────┬─────────────────────────────┘
             │
             ▼
┌──────────────────────────────────────────┐
│  Spring MVC Controllers                  │
│  AuthenticationController                │
│  AppointmentController                   │
│  DoctorController (/admin/**)            │
└───────┬──────────────┬───────────────────┘
        │              │
        ▼              ▼
┌─────────────┐  ┌──────────────┐
│ JSP Views   │  │ JPA / Hibernate
│ (WEB-INF/   │  │ (Repositories)│
│  views/)    │  └──────┬───────┘
└─────────────┘         │
                        ▼
              ┌──────────────────┐
              │   Database        │
              │  MySQL / Postgres │
              │  / H2             │
              └──────────────────┘
```

---

## Project Structure

```
dentcare/
├── src/main/java/com/subrat/clinic/
│   ├── config/
│   │   ├── SecurityConfig.java          # Spring Security filter chain + BCrypt
│   │   ├── DataInitializer.java         # Creates default admin on first run
│   │   └── GlobalModelAdvice.java       # Adds role info to all JSP models
│   ├── controller/
│   │   ├── AuthenticationController.java # Login, register, profile, password
│   │   ├── AppointmentController.java   # Home, book, static pages, my appointments
│   │   └── DoctorController.java        # Admin CRUD: doctors, patients, appointments
│   ├── model/
│   │   ├── Doctor.java
│   │   ├── Patient.java
│   │   └── Appointment.java
│   ├── repository/                      # Spring Data JPA interfaces
│   └── service/ + service/impl/         # Business logic
├── src/main/resources/
│   ├── application.properties           # Default (MySQL local)
│   ├── application-local.properties     # H2 zero-config
│   └── application-prod.properties      # PostgreSQL (Render)
├── src/main/webapp/WEB-INF/views/
│   ├── index.jsp                        # Home page
│   ├── login.jsp                        # Login (username = email)
│   ├── register.jsp                     # Patient registration
│   ├── book_appointment.jsp             # Book appointment
│   ├── my_appointments.jsp              # Patient: view own bookings
│   ├── profile.jsp                      # Patient profile
│   ├── change_password.jsp              # Patient: change password
│   ├── about.jsp / service.jsp / ...    # Marketing static pages
│   ├── doctor_list.jsp                  # Admin: doctor table
│   ├── doctor_form.jsp                  # Admin: add/edit doctor
│   ├── patient_list.jsp                 # Admin: patient table
│   └── admin/
│       ├── dashboard.jsp                # Admin dashboard
│       ├── appointment_list.jsp         # Admin: all appointments
│       └── edit_appointment.jsp         # Admin: edit appointment
├── Dockerfile
├── render.yaml                          # Render Blueprint (auto-provisions DB)
└── .github/workflows/build.yml          # CI: build + Docker smoke test
```

---

## Endpoints

| Method | Path                   | Auth     | Description                 |
|--------|------------------------|----------|-----------------------------|
| GET    | `/`                    | Public   | Home page                   |
| GET    | `/login`               | Public   | Login page                  |
| POST   | `/login`               | Public   | Process login (Spring Sec)  |
| GET    | `/register`            | Public   | Registration page           |
| POST   | `/register`            | Public   | Create patient account      |
| GET    | `/about` `/service` etc| Public   | Marketing pages             |
| GET    | `/book_appointment`    | Public   | Booking form                |
| POST   | `/book`                | Public   | Submit appointment          |
| GET    | `/profile`             | ROLE_USER| Patient profile             |
| GET    | `/change-password`     | ROLE_USER| Change password form        |
| POST   | `/change-password`     | ROLE_USER| Submit new password         |
| GET    | `/my/appointments`     | ROLE_USER| Patient's own bookings      |
| GET    | `/admin/dashboard`     | ROLE_ADMIN| Admin dashboard            |
| GET    | `/admin/doctors`       | ROLE_ADMIN| List doctors               |
| GET    | `/admin/doctors/add`   | ROLE_ADMIN| Add doctor form            |
| POST   | `/admin/doctors/save`  | ROLE_ADMIN| Save doctor                |
| GET    | `/admin/patients`      | ROLE_ADMIN| List patients              |
| GET    | `/admin/appointments`  | ROLE_ADMIN| List all appointments      |
| GET    | `/admin/appointments/edit/{id}` | ROLE_ADMIN | Edit appointment |
| POST   | `/admin/appointments/update`    | ROLE_ADMIN | Update appointment |
| GET    | `/admin/appointments/delete/{id}` | ROLE_ADMIN | Delete appointment |
| POST   | `/logout`              | Authenticated | Logout                |
| GET    | `/actuator/health`     | Public   | Health check (Docker/Render)|

---

## Security

- **Passwords:** BCrypt-hashed (via Spring Security `PasswordEncoder`)
- **CSRF:** Enabled on all forms (via `${_csrf}` hidden inputs)
- **Session fixation:** Prevented by Spring Security (session ID regenerated on login)
- **Authorization:** Role-based route guards in `SecurityConfig`
- **Admin default credentials:** `dentcare.support@gmail.com` / `admin123` (auto-created on first run)

---

## Local Setup

### Prerequisites
- Java 17+ (or 22+)
- Maven (or use `./mvnw` wrapper)
- MySQL 8 running locally (or use H2 — no install needed)

### Option A: Zero-config (H2, no MySQL required)

```bash
mvn clean package -DskipTests
java -jar target/dentcare.jar --spring.producers.active=local
# Open http://localhost:8080
```

### Option B: MySQL (requires MySQL running)

```bash
# Ensure MySQL is running at localhost:3306 with clinic_db created:
# CREATE DATABASE clinic_db;

# Set environment variables (or edit application.properties):
export DB_USERNAME=root
export DB_PASSWORD=yourpassword
export HIBERNATE_DIALECT=org.hibernate.dialect.MySQL8Dialect

mvn clean package -DskipTests
java -jar target/dentcare.jar
# Open http://localhost:8080
```

### Default Admin Login
- **Email:** `dentcare.support@gmail.com`
- **Password:** `admin123`

---

## Deployment (Render.com — Free)

1. Push this repo to GitHub and rename it to `Dentcare`

2. Go to [Render.com](https://dashboard.render.com) → **New Blueprint** → connect your GitHub repo

3. Render will read `render.yaml` and automatically:
   - Create a free PostgreSQL database (`dentcare-db`)
   - Create a free web service (`dentcare`) with Docker build
   - Set all required env vars

4. Click **Deploy** — your app will be live at `https://carebydent.onrender.com`

> Render free instances spin down after 15 min of inactivity and take ~30s to wake up.

### GitHub Actions CI

Every push to `main` triggers:
- Maven build + JAR artifact upload
- Docker image build + smoke test (curl health endpoint)
- Render auto-deploys on push to `main`

---

## Environment Variables

| Variable             | Default                                          | Description               |
|----------------------|--------------------------------------------------|---------------------------|
| `PORT`               | `8080`                                           | Server port               |
| `DB_URL`             | `jdbc:mysql://localhost:3306/clinic_db`           | MySQL URL (local)         |
| `DB_USERNAME`        | `root`                                           | MySQL username (local)    |
| `DB_PASSWORD`        | `root`                                           | MySQL password (local)    |
| `DB_HOST`            | —                                                | PostgreSQL host (prod)    |
| `DB_PORT`            | —                                                | PostgreSQL port (prod)    |
| `DB_NAME`            | —                                                | PostgreSQL database (prod)|
| `DB_USER`            | —                                                | PostgreSQL user (prod)    |
| `DB_PASSWORD`        | —                                                | PostgreSQL password (prod)|
| `SPRING_PROFILES_ACTIVE` | `default`                                    | Active profile            |
| `JAVA_OPTS`          | —                                                | Extra JVM flags (Docker)  |

---

## License

This project is for educational / portfolio use.
