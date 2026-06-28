-- Run this in Supabase SQL Editor

create table if not exists page_views (
  id         uuid primary key default gen_random_uuid(),
  page       text not null,
  referrer   text,
  viewed_at  timestamptz default now()
);

alter table page_views enable row level security;

create policy "Public insert page_views" on page_views for insert with check (true);
create policy "Auth read page_views" on page_views for select using (auth.role() = 'authenticated');
