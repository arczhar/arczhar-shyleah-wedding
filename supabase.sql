create extension if not exists pgcrypto;

create table if not exists public.rsvps (
  id uuid primary key default gen_random_uuid(),

  full_name text not null
    check (char_length(trim(full_name)) between 2 and 120),

  attending boolean not null,

  message text
    check (
      message is null
      or char_length(message) <= 1000
    ),

  created_at timestamptz not null default now()
);

alter table public.rsvps enable row level security;

revoke all on table public.rsvps from anon, authenticated;

grant usage on schema public to anon;
grant insert on table public.rsvps to anon;

drop policy if exists "Public can submit RSVP"
on public.rsvps;

create policy "Public can submit RSVP"
on public.rsvps
for insert
to anon
with check (true);