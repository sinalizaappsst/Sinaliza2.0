-- CORREÇÃO SINALIZA - PERFIS E BASE CENTRAL
-- Execute no Supabase > SQL Editor > New query.
-- Ajusta João como administrador e reseta a base JSON para o app recriar os dados completos do HTML aprovado.

-- 1) Garantir que o perfil do João seja ADMIN.
-- Atenção: existem duas grafias usadas nos testes. O SQL corrige as duas, caso existam.
update public.profiles
set
  full_name = 'João Gabriel Trindade',
  role = 'admin',
  active = true,
  updated_at = now()
where lower(email) in (
  lower('joaotrindade@hotmail.com'),
  lower('joaotrindaade@hotmail.com')
);

-- 2) Usuário de teste opcional: ajuste aqui o perfil do segundo usuário.
-- Mude para 'requester' se quiser que ele seja solicitante, ou 'executor' se quiser testar execução.
update public.profiles
set
  full_name = coalesce(nullif(full_name,''), 'Usuário Teste'),
  role = 'executor',
  active = true,
  updated_at = now()
where lower(email) = lower('seg9@frandolozo.com');

-- 3) Limpar a base central antiga/incompleta.
-- No próximo login, o app recria a base com mapa, assistente, checklists, OAEs e dados de demonstração completos.
delete from public.sinaliza_app_state
where id = '00000000-0000-4000-8000-000000000001'::uuid;

-- 4) Conferência.
select id, full_name, email, role, active
from public.profiles
order by created_at;
