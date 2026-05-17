create table if not exists public.site_content (
  key text primary key,
  content jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.site_content enable row level security;

drop policy if exists "Public can read site content" on public.site_content;
create policy "Public can read site content"
on public.site_content for select
using (true);

drop policy if exists "Authenticated admins can insert site content" on public.site_content;
create policy "Authenticated admins can insert site content"
on public.site_content for insert
to authenticated
with check (true);

drop policy if exists "Authenticated admins can update site content" on public.site_content;
create policy "Authenticated admins can update site content"
on public.site_content for update
to authenticated
using (true)
with check (true);

insert into storage.buckets (id, name, public)
values ('clinic-media', 'clinic-media', true)
on conflict (id) do update set public = true;

drop policy if exists "Public can read clinic media" on storage.objects;
create policy "Public can read clinic media"
on storage.objects for select
using (bucket_id = 'clinic-media');

drop policy if exists "Authenticated admins can upload clinic media" on storage.objects;
create policy "Authenticated admins can upload clinic media"
on storage.objects for insert
to authenticated
with check (bucket_id = 'clinic-media');

drop policy if exists "Authenticated admins can update clinic media" on storage.objects;
create policy "Authenticated admins can update clinic media"
on storage.objects for update
to authenticated
using (bucket_id = 'clinic-media')
with check (bucket_id = 'clinic-media');

drop policy if exists "Authenticated admins can delete clinic media" on storage.objects;
create policy "Authenticated admins can delete clinic media"
on storage.objects for delete
to authenticated
using (bucket_id = 'clinic-media');
