# FieldPulse — Field Technician Job Management

A production-ready mobile application for field service technicians to receive job assignments,
complete dynamic checklists, capture photos & signatures, and sync everything offline-first.

---

## Stack

| Layer | Technology |
|---|---|
| Mobile | Flutter 3.x, Riverpod, GoRouter, Drift (SQLite), Dio |
| Backend | Django 4.2, Django REST Framework, PostgreSQL |
| Storage | MinIO (S3-compatible) |
| Auth | JWT (simplejwt) + Biometric (local_auth) |
| Notifications | Firebase Cloud Messaging |

---

## Prerequisites

- Docker Desktop
- Flutter SDK 3.2+
- Python 3.11+
- Node.js (for Firebase CLI)

---

## Quick Start (Fresh Machine)

### 1. Clone & configure environment
```bash
git clone https://github.com/your-org/fieldpulse.git
cd fieldpulse
cp .env.example .env
```

Edit `.env` and set a strong `SECRET_KEY` (min 32 chars):
```bash
python -c "import secrets; print(secrets.token_hex(32))"
```

### 2. Start infrastructure
```bash
docker compose up db minio -d
```

Wait ~10 seconds for Postgres to be ready, then:

### 3. Set up backend
```bash
cd backend
python -m venv venv

# Windows
venv\Scripts\activate
# macOS/Linux
source venv/bin/activate

pip install -r requirements.txt
python manage.py migrate
python manage.py seed_jobs
python manage.py runserver 0.0.0.0:8000
```

Backend now running at `http://localhost:8000`

### 4. Set up Flutter app
```bash
cd mobile
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

Configure the API base URL in `lib/core/constants/api_constants.dart`:
```dart
// Android emulator
static const String baseUrl = 'http://10.0.2.2:8000/api';

// Physical device — use your machine's local IP
static const String baseUrl = 'http://192.168.x.x:8000/api';
```

### 5. Firebase setup (for push notifications)
```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
firebase login
cd mobile
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID --platforms=android,ios
```

### 6. Run the app
```bash
flutter run
```

### Demo credentials

---

## Running Tests

### Backend tests
```bash
cd backend
python manage.py test apps
```

### Flutter unit + integration tests
```bash
cd mobile
flutter test test/unit/
flutter test test/integration/
```

### Flutter E2E tests
```bash
cd mobile
flutter test integration_test/app_test.dart
```

---

## API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| POST | /api/auth/login/ | Email + password → JWT tokens |
| POST | /api/auth/refresh/ | Refresh access token |
| POST | /api/auth/logout/ | Blacklist refresh token |
| GET | /api/auth/profile/ | Current user |
| GET | /api/jobs/ | List jobs (paginated, filtered) |
| GET | /api/jobs/{id}/ | Job detail + schema |
| PATCH | /api/jobs/{id}/status/ | Update status |
| POST | /api/checklist/{id}/draft/ | Save draft |
| POST | /api/checklist/{id}/submit/ | Submit checklist |
| POST | /api/media/photo/ | Upload photo |
| POST | /api/media/signature/ | Upload signature |
| POST | /api/sync/bulk/ | Batch sync |
| POST | /api/sync/conflict/resolve/ | Resolve conflict |

---

## Known Limitations

- iOS push notifications require APNs key upload to Firebase Console
- Google Maps on Android requires a Maps API key in AndroidManifest.xml
- Background sync (WorkManager/BGTaskScheduler) not implemented — sync triggers on app foreground
- Photo upload progress is per-field, not per-individual-photo in multi-photo fields
- E2E tests require a running backend on the test device's network

---
## Platform Testing

### Android
Tested and verified on:
- Physical device: Samsung Galaxy (Android 14)
- Features verified: Login, biometrics, job list,
  checklist, photo capture, signature, offline sync

### iOS
- iOS build verified via GitHub Actions (macOS runner)
- See Actions tab for build logs
- Physical iOS device testing pending Mac access
- All platform-specific code uses Flutter's
  cross-platform APIs (local_auth, camera, geolocator)
  which are fully iOS compatible