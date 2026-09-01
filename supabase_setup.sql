-- SINALIZA WEB OPERACIONAL - SUPABASE SETUP
-- Execute este script no Supabase em SQL Editor > New query.
-- Não cole chaves secretas aqui.

create extension if not exists pgcrypto;

-- 1) Perfil dos usuários autenticados
-- Compatível com valores usados no app: admin, requester e executor.
do $$
begin
  if not exists (select 1 from pg_type where typnamespace = 'public'::regnamespace and typname = 'sinaliza_role') then
    create type public.sinaliza_role as enum ('admin', 'requester', 'executor');
  end if;
end $$;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  email text unique,
  role public.sinaliza_role not null default 'requester',
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.touch_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists profiles_touch_updated_at on public.profiles;
create trigger profiles_touch_updated_at
before update on public.profiles
for each row execute function public.touch_updated_at();

create or replace function public.handle_new_user_profile()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, email, role, active)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', split_part(new.email, '@', 1), 'Usuário'),
    new.email,
    'requester',
    true
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created_sinaliza_profile on auth.users;
create trigger on_auth_user_created_sinaliza_profile
after insert on auth.users
for each row execute function public.handle_new_user_profile();

alter table public.profiles enable row level security;

drop policy if exists profiles_select_own on public.profiles;
drop policy if exists profiles_select_admin on public.profiles;
drop policy if exists profiles_update_own_name on public.profiles;
drop policy if exists profiles_admin_update on public.profiles;
drop policy if exists "profiles_select_own" on public.profiles;
drop policy if exists "profiles_admin_select_all" on public.profiles;
drop policy if exists "profiles_update_own" on public.profiles;

create or replace function public.is_sinaliza_admin(user_id uuid)
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.profiles
    where id = user_id
      and role::text = 'admin'
      and active = true
  );
$$;

grant execute on function public.is_sinaliza_admin(uuid) to authenticated;

create policy profiles_select_own
on public.profiles for select
to authenticated
using (id = auth.uid());

create policy profiles_select_admin
on public.profiles for select
to authenticated
using (public.is_sinaliza_admin(auth.uid()));

create policy profiles_update_own_name
on public.profiles for update
to authenticated
using (id = auth.uid())
with check (id = auth.uid());

create policy profiles_admin_update
on public.profiles for update
to authenticated
using (public.is_sinaliza_admin(auth.uid()))
with check (public.is_sinaliza_admin(auth.uid()));

-- 2) Estado operacional central do app
-- Esta versão salva o estado do Sinaliza em um JSON central para entregar um sistema funcional rapidamente.
-- Próxima evolução: normalizar em tabelas operations, oae_projects, map_groups etc.
create table if not exists public.sinaliza_app_state (
  id uuid primary key default '00000000-0000-4000-8000-000000000001'::uuid,
  data jsonb not null default '{}'::jsonb,
  updated_by uuid references auth.users(id),
  updated_at timestamptz not null default now()
);

alter table public.sinaliza_app_state enable row level security;

drop policy if exists sinaliza_state_select_authenticated on public.sinaliza_app_state;
drop policy if exists sinaliza_state_insert_authenticated on public.sinaliza_app_state;
drop policy if exists sinaliza_state_update_authenticated on public.sinaliza_app_state;

create policy sinaliza_state_select_authenticated
on public.sinaliza_app_state for select
to authenticated
using (true);

create policy sinaliza_state_insert_authenticated
on public.sinaliza_app_state for insert
to authenticated
with check (true);

create policy sinaliza_state_update_authenticated
on public.sinaliza_app_state for update
to authenticated
using (true)
with check (true);

-- 3) Storage para evidências
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'sinaliza-evidences',
  'sinaliza-evidences',
  false,
  52428800,
  array['image/jpeg','image/png','image/webp','image/heic','video/mp4','video/quicktime','audio/mpeg','audio/mp4','audio/webm','audio/wav','application/pdf']
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "sinaliza evidence read authenticated" on storage.objects;
drop policy if exists "sinaliza evidence upload authenticated" on storage.objects;
drop policy if exists "sinaliza evidence update authenticated" on storage.objects;
drop policy if exists "sinaliza evidence delete authenticated" on storage.objects;

create policy "sinaliza evidence read authenticated"
on storage.objects for select
to authenticated
using (bucket_id = 'sinaliza-evidences');

create policy "sinaliza evidence upload authenticated"
on storage.objects for insert
to authenticated
with check (bucket_id = 'sinaliza-evidences');

create policy "sinaliza evidence update authenticated"
on storage.objects for update
to authenticated
using (bucket_id = 'sinaliza-evidences')
with check (bucket_id = 'sinaliza-evidences');

create policy "sinaliza evidence delete authenticated"
on storage.objects for delete
to authenticated
using (bucket_id = 'sinaliza-evidences');

-- 4) Transformar seu usuário atual em administrador.
-- Troque o e-mail abaixo pelo e-mail exato cadastrado no Authentication > Users.
update public.profiles
set full_name = 'João Gabriel Trindade', role = 'admin', active = true
where lower(email) = lower('joaotrindaade@hotmail.com');

select id, full_name, email, role, active from public.profiles order by created_at;
