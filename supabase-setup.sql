-- ═══════════════════════════════════════════════════════
-- Run this entire file in the Supabase SQL Editor once.
-- ═══════════════════════════════════════════════════════

-- ── TABLES ──────────────────────────────────────────────

create table if not exists profile (
  id int primary key default 1,
  name text default 'Samaira Talwar',
  tagline text default 'Economist · Editor-in-Chief · Journalist · Pre-Law',
  bio_hero text default 'Third-year Economics student at UBC Okanagan. I lead teams, tell stories, design for communities, and bridge ideas across disciplines.',
  bio_about text default 'I''m Samaira Talwar — a third-year Economics student at UBC Okanagan with a Pre-Law focus and a long track record of actually doing things.',
  bio_about_2 text default 'At The Phoenix News, I started as a Social Media Manager in 2024, grew their audience by 70%, moved into Operations, started writing, and by 2026 I was Editor-in-Chief.',
  bio_about_3 text default 'I''ve also coordinated 135 mentorship matches, advised 50+ residents, designed life books for foster children, tutored in three languages, and counselled 25+ middle schoolers.',
  job_title text default 'Editor-in-Chief, The Phoenix News',
  location text default 'Kelowna, BC',
  university text default 'UBC Okanagan',
  degree text default 'Bachelor of Arts — Economics',
  year text default '3rd Year · Pre-Law Track',
  email text default 'samairatlwr@gmail.com',
  linkedin_url text default 'https://www.linkedin.com/in/samaira-talwar-069a60210/',
  phoenix_author_url text default 'https://thephoenixnews.com/author/samaira-talwar'
);
insert into profile (id) values (1) on conflict do nothing;

create table if not exists stats (
  id serial primary key,
  value text not null,
  label text not null,
  sort_order int default 0
);

create table if not exists articles (
  id uuid default gen_random_uuid() primary key,
  title text not null,
  category text not null,
  date_str text not null,
  url text not null,
  preview text,
  featured boolean default false,
  sort_order int default 0,
  created_at timestamptz default now()
);

create table if not exists experience (
  id uuid default gen_random_uuid() primary key,
  org text not null,
  role text not null,
  date_range text not null,
  location text,
  exp_type text default 'work',  -- 'work' or 'volunteer'
  is_current boolean default false,
  description text,
  bullets text,   -- newline-separated bullet points
  tags text,      -- comma-separated
  sort_order int default 0
);

create table if not exists certifications (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  issuer text not null,
  date_str text,
  cert_url text,
  sort_order int default 0
);

create table if not exists languages (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  level_label text not null,
  level_pct int not null default 50,
  color text default 'var(--black)',
  sort_order int default 0
);

create table if not exists skills (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  sort_order int default 0
);

-- ── ROW LEVEL SECURITY ───────────────────────────────────
-- Everyone can read; only logged-in admin can write.

alter table profile        enable row level security;
alter table stats          enable row level security;
alter table articles       enable row level security;
alter table experience     enable row level security;
alter table certifications enable row level security;
alter table languages      enable row level security;
alter table skills         enable row level security;

-- Public read policies
create policy "public read profile"        on profile        for select using (true);
create policy "public read stats"          on stats          for select using (true);
create policy "public read articles"       on articles       for select using (true);
create policy "public read experience"     on experience     for select using (true);
create policy "public read certifications" on certifications for select using (true);
create policy "public read languages"      on languages      for select using (true);
create policy "public read skills"         on skills         for select using (true);

-- Authenticated write policies
create policy "auth write profile"        on profile        for all using (auth.role() = 'authenticated');
create policy "auth write stats"          on stats          for all using (auth.role() = 'authenticated');
create policy "auth write articles"       on articles       for all using (auth.role() = 'authenticated');
create policy "auth write experience"     on experience     for all using (auth.role() = 'authenticated');
create policy "auth write certifications" on certifications for all using (auth.role() = 'authenticated');
create policy "auth write languages"      on languages      for all using (auth.role() = 'authenticated');
create policy "auth write skills"         on skills         for all using (auth.role() = 'authenticated');

-- ── SEED DATA ────────────────────────────────────────────

insert into stats (value, label, sort_order) values
  ('12',  'Articles published across 5 editorial sections', 1),
  ('70%', 'Audience growth driven as Social Media Manager', 2),
  ('135', 'Mentorship matches facilitated for first-year students', 3),
  ('6',   'Languages spoken across three continents'' worth of context', 4)
on conflict do nothing;

insert into articles (title, category, date_str, url, preview, featured, sort_order) values
  ('Inside the 2026 Relay for Life', 'Campus Life', 'Mar 28, 2026', 'https://thephoenixnews.com/posts/inside-the-2026-relay-for-life', 'How UBCO turned a Sunday into $54,131 raised for cancer research.', true, 1),
  ('Who Turned Up the HEAT in the Furnace?', 'Sports', 'Mar 16, 2026', 'https://thephoenixnews.com/posts/who-turned-up-the-heat-in-the-furnace', 'Heat, hustle, and heart — inside UBCO''s fiercest athletic showdown.', false, 2),
  ('Too Much Flesh, Not Enough Fleshiness', 'Arts & Culture', 'Nov 24, 2025', 'https://thephoenixnews.com/posts/too-much-flesh-not-enough-fleshiness', 'Bodies, representation, and what contemporary art leaves behind.', false, 3),
  ('Shutdowns & Showdowns: When Democracies Hit The Wall', 'Opinions', 'Oct 16, 2025', 'https://thephoenixnews.com/posts/shutdowns-and-showdowns-when-democracies-hit-the-wall', 'When governments grind to a halt — what it says about democracy''s health.', false, 4),
  ('You''re Probably Hug Deprived', 'Science & Tech', 'Apr 6, 2025', 'https://thephoenixnews.com/posts/youre-probably-hug-deprived', 'The science of oxytocin and why physical touch matters more than you think.', false, 5),
  ('Press Start To Escape', 'Science & Tech', 'Mar 31, 2025', 'https://thephoenixnews.com/posts/press-start-to-escape', 'Video games as mental refuge — when play becomes a coping mechanism.', false, 6),
  ('Digital Detoxes For Dopa-fiends', 'Science & Tech', 'Mar 31, 2025', 'https://thephoenixnews.com/posts/digital-detoxes-for-dopa-fiends', 'Dopamine, screens, and the uncomfortable truth about your phone habits.', false, 7),
  ('Stuart Little (Not So Little Anymore)', 'Science & Tech', 'Mar 17, 2025', 'https://thephoenixnews.com/posts/stuart-little-not-so-little-anymore', 'How lab mice became the unlikely heroes of modern medical research.', false, 8),
  ('From Für Elise to Mind at Ease', 'Science & Tech', 'Mar 17, 2025', 'https://thephoenixnews.com/posts/from-fur-elise-to-mind-at-ease', 'The neuroscience of music — why Beethoven might be the best therapist you''ve never paid.', false, 9),
  ('Smoking Under The Placebo Gazebo', 'Science & Tech', 'Mar 5, 2025', 'https://thephoenixnews.com/posts/smoking-under-the-placebo-gazebo', 'The placebo effect is real, powerful, and stranger than you ever imagined.', false, 10),
  ('The Geniuses They Won''t Teach You About', 'Science & Tech', 'Mar 5, 2025', 'https://thephoenixnews.com/posts/the-geniuses-they-wont-teach-you-about', 'The brilliant minds history overlooked — and why their erasure still matters.', false, 11),
  ('About The Fault In ''Our Stars''', 'Science & Tech', 'Feb 4, 2025', 'https://thephoenixnews.com/posts/about-the-fault-in-our-stars', 'Star naming, space myths, and the human desire to leave a mark on the universe.', false, 12)
on conflict do nothing;

insert into experience (org, role, date_range, location, exp_type, is_current, bullets, tags, sort_order) values
  ('The Phoenix News', 'Editor-in-Chief', 'May 2026 – Present', 'UBC Okanagan', 'work', true,
   'Direct editorial operations — managing article production, publication timelines, and a team of writers, editors, photographers, and designers
Coordinate cross-functional collaboration with faculty advisors for timely print and digital delivery
Oversee layout planning, content organization, and final approval for all releases
Organize editorial meetings, assign story pitches, and maintain strict publishing deadlines', 'Editorial Leadership,Team Management,Content Strategy,Publishing', 1),

  ('KCR Community Resources', 'Lifebook Designer', 'May 2026 – Present', 'Kelowna, BC', 'work', true,
   'Design 10+ customizable digital life book templates for foster children
Collaborate with frontline staff to develop trauma-informed, child-centred designs
Create printable templates in PowerPoint and Canva, reducing formatting time across client materials', 'Design,Canva,Non-Profit,Trauma-Informed', 2),

  ('Aberdeen Hall Preparatory School', 'After-School Counsellor', 'May 2026 – Present', 'Kelowna, BC', 'work', true,
   'Manage supervision and oversight of 25+ middle school students
Design and lead 4 weekly programs, allocating resources across competing priorities
Mediate interpersonal conflicts, developing negotiation and dispute resolution skills', 'Counselling,Program Design,Conflict Mediation', 3),

  ('UBC Library', 'Writing & Language Consultant', 'Sep 2025 – Present', 'Kelowna, BC', 'work', true,
   'Support students in strengthening academic writing, communication, and critical thinking
Guide all stages of the writing process — brainstorming, drafting, revising, polishing
Provide multilingual support in English, French, and Spanish', 'Writing,Multilingual,Academic Support,Mentorship', 4),

  ('UBC Okanagan', 'Orientation Leader', 'Aug – Sep 2025', 'Kelowna, BC', 'work', false,
   'Welcomed and supported incoming first-year students through Jumpstart and Create programs
Facilitated group activities and collaborated with staff to execute orientation events
Promoted campus resources to empower new students for academic and personal success', 'Student Leadership,Event Facilitation', 5),

  ('UBC Student Housing', 'Residence Learning Initiatives Coordinator', 'May 2025 – May 2026', 'Kelowna, BC', 'work', false,
   'Planned and evaluated the RACP, facilitating 135 mentorship matches for first-year residents
Collaborated with 12+ Residence Advisors; gathered feedback from 200+ residents
Developed residence-wide educational workshops promoting inclusive, growth-oriented environments', 'Program Coordination,Community Building,Strategic Planning', 6),

  ('The Phoenix News', 'Operations Manager', 'Apr 2025 – May 2026', 'UBC Okanagan', 'work', false,
   'Coordinated volunteer writers, managed internal communications, led weekly editorial meetings
Reviewed monthly reports to support strategic planning
Managed advertising placements and operational logistics to sustain publication growth', 'Operations,Team Coordination,Strategic Planning', 7),

  ('The Phoenix News', 'Science & Tech Writer', 'Jan – Apr 2025', 'UBC Okanagan', 'work', false,
   'Researched and wrote clear, engaging weekly articles on science and technology topics
Collaborated with editors and subject-matter experts to ensure accuracy and accessibility
Tracked emerging trends to pitch timely, data-informed story ideas', 'Science Communication,Feature Writing,Research', 8),

  ('UBC Student Housing', 'Resident Advisor', 'Aug 2024 – Apr 2025', 'Kelowna, BC', 'work', false,
   'Led a community of 50+ residents through mentorship, conflict mediation, and crisis response
Organized educational, social, and wellness programs to promote student engagement
Enforced university policies while developing leadership, communication, and problem-solving skills', 'Residential Leadership,Crisis Response,Event Planning', 9),

  ('The Phoenix News', 'Social Media Manager', 'Jan 2024 – Feb 2025', '', 'work', false,
   'Led social media strategy across platforms, increasing follower growth by 70%
Created multimedia content tailored to platform algorithms and reader interests
Analyzed performance metrics and adjusted campaigns in real time through data-driven insights', 'Social Media,Analytics,Content Creation,Growth Strategy', 10),

  ('Inkelt Innovations', 'Content Writer', '2023', '', 'work', false,
   'Produced written material for digital platforms, developing foundational skills in brand voice and editorial consistency', 'Content Writing,Digital Media', 11),

  ('Zeal', 'Founder', 'Jun 2023', 'India · Remote', 'work', false,
   'Founded an NGO offering workshops in mental health, academia, communication, and self-presentation for young people from diverse backgrounds', 'Entrepreneurship,NGO,Workshop Design', 12),

  ('TEDxUBCO', 'Volunteer', 'UBC Okanagan', '', 'volunteer', false,
   'Supported the TEDxUBCO event, amplifying student and community voices on campus
Engaged with speakers, attendees, and organizing teams to ensure a meaningful event experience', 'Event Support,Community', 100)
on conflict do nothing;

insert into languages (name, level_label, level_pct, color, sort_order) values
  ('English', 'Native',        100, 'var(--black)',  1),
  ('Hindi',   'Fluent',         95, 'var(--coral)',  2),
  ('French',  'Fluent',         88, 'var(--blue)',   3),
  ('Spanish', 'Conversational', 55, 'var(--purple)', 4),
  ('Korean',  'Learning',       35, '#888',          5),
  ('Mandarin','Learning',       30, '#aaa',          6)
on conflict do nothing;

insert into skills (name, sort_order) values
  ('Editorial Leadership', 1), ('Feature Writing', 2), ('Science Communication', 3),
  ('Research & Analysis', 4), ('Political Commentary', 5), ('Arts Criticism', 6),
  ('Social Media Strategy', 7), ('Data-Driven Campaigns', 8), ('Program Coordination', 9),
  ('Conflict Mediation', 10), ('Crisis Response', 11), ('Canva & PowerPoint', 12),
  ('AP Style', 13), ('Academic Writing', 14), ('Mentorship', 15),
  ('Community Building', 16), ('Economics', 17), ('Pre-Law', 18),
  ('Workshop Facilitation', 19), ('Trauma-Informed Design', 20), ('Multilingual', 21)
on conflict do nothing;
