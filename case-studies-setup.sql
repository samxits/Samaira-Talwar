-- Run this in Supabase SQL Editor to add the case_studies table

create table if not exists case_studies (
  id          uuid primary key default gen_random_uuid(),
  title       text not null,
  org         text,
  year        text,
  tags        text,
  problem     text,
  approach    text,
  results     text,  -- one result per line: "70% | Audience growth"
  sort_order  integer default 0,
  created_at  timestamptz default now()
);

alter table case_studies enable row level security;

create policy "Public read case_studies" on case_studies for select using (true);
create policy "Auth write case_studies" on case_studies for all using (auth.role() = 'authenticated');
