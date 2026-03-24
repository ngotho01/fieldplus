\# FieldPulse — Architecture Decisions



\## State Management: Riverpod



Chose Riverpod over Bloc because this project is async-heavy — JWT refresh,

offline queue processing, sync, and biometric auth all run concurrently.

Riverpod's `AsyncNotifier` and `FutureProvider.family` handle these cleanly

without the event/state boilerplate that Bloc requires. Compile-time safety

and the provider override system (used in tests) were also strong factors.



\## Offline Storage: Drift (SQLite)



Chose Drift over Hive/Isar because the sync queue requires relational queries

— filtering by retry count, joining jobs to their checklist responses, ordering

by created\_at. Drift's type-safe generated DAOs eliminate a whole class of

runtime errors. The `part of` library pattern keeps all DB code in one

compilation unit, which is what Drift's code generator expects.



\## Offline-First Architecture



All user actions write to local SQLite first, then enqueue a sync item.

The `SyncQueue` table acts as a durable outbox — if the app crashes mid-sync,

items remain in the queue. The `SyncService` processes the queue on:

1\. App foreground (connectivity check)

2\. Connectivity restored (via `connectivity\_plus` stream)

3\. Manual "Sync Now" tap



Each queue item tracks `retry\_count`. Items that fail 3+ times are skipped

and flagged to the user rather than blocking the entire queue.



\## Conflict Resolution



Used `server\_version` (integer) on the `Job` model. On every status update

or checklist submit, the client sends its known version. If the server version

has advanced, a 409 is returned with the current server state. The client then

shows a conflict dialog offering three resolutions:

\- \*\*Keep Local\*\* — client version wins, server\_version bumped to allow the write

\- \*\*Accept Server\*\* — client discards local changes, refreshes from server

\- \*\*Merge\*\* — for text fields only, user manually resolves field by field



\## JWT + Token Refresh



Access tokens expire in 15 minutes. The Dio interceptor catches 401 responses,

silently attempts a refresh using the 7-day refresh token, then retries the

original request. If refresh fails, the session is cleared and the user is

redirected to login. The `rotate\_refresh\_tokens` + `blacklist\_after\_rotation`

settings prevent refresh token reuse.



\## File Storage: MinIO (S3-compatible)



MinIO mirrors production AWS S3 behaviour locally. Django generates pre-signed

URLs for downloads (1-hour expiry). Photos upload via multipart to Django which

streams to MinIO — this keeps the Flutter app simple (one POST) while keeping

the backend stateless for horizontal scaling.



\## Dynamic Checklist Schema



The schema is a JSON field on `ChecklistSchema` model. Flutter renders fields

dynamically using a `switch` on `field\['type']`. This means new field types can

be added backend-side without a mobile app update — only the renderer needs a

new `case`. Validation runs both client-side (immediate UX) and server-side

(source of truth).



\## Biometric Auth



Biometric is opt-in, enabled after first successful password login. The

preference is stored in `flutter\_secure\_storage` (Keychain on iOS,

Keystore-backed on Android). On subsequent launches, if biometric is enabled,

the system prompt fires before any API call is made. Failed/cancelled biometric

clears the session entirely — no silent fallback to an unprotected state.



\## What I'd Do Differently With More Time



\- \*\*Background sync\*\* using WorkManager (Android) / BGTaskScheduler (iOS)

&#x20; so sync runs even when the app is not in the foreground

\- \*\*WebSocket\*\* for real-time job assignment push instead of FCM polling

\- \*\*E2E tests with Patrol\*\* — better Flutter integration than Detox

\- \*\*MapLibre\*\* instead of google\_maps\_flutter for offline map tile caching

\- \*\*Optimistic UI\*\* on status updates — update the list card immediately

&#x20; instead of waiting for the API round-trip

\- \*\*Photo upload chunking\*\* for large files on slow connections

