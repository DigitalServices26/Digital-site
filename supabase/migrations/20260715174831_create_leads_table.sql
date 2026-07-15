/*
# Create leads table (single-tenant, no auth)

1. New Tables
- `leads`
  - `id` (uuid, primary key)
  - `name` (text, not null) — submitter's full name
  - `email` (text, not null) — submitter's email
  - `website` (text) — optional website URL
  - `service` (text) — selected service of interest
  - `message` (text) — project details / free-text message
  - `created_at` (timestamptz, defaults to now())
2. Security
- Enable RLS on `leads`.
- Allow anon + authenticated to INSERT only (public lead-gen form).
- No SELECT/UPDATE/DELETE for anon or authenticated — leads are managed
  server-side only, so public visitors cannot read or enumerate submissions.
3. Notes
- This is a single-tenant public contact form with no sign-in, so the anon
  role must be able to insert. Reads are intentionally locked down to keep
  submissions private.
*/

CREATE TABLE IF NOT EXISTS leads (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text NOT NULL,
  website text,
  service text,
  message text,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE leads ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_leads" ON leads;
CREATE POLICY "anon_insert_leads"
ON leads FOR INSERT
TO anon, authenticated
WITH CHECK (true);
