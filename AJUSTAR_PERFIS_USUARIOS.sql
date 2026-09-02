-- SINALIZA - AJUSTAR PERFIS DE USUÁRIOS
-- Execute no Supabase > SQL Editor > New query.
-- Use este arquivo sempre que criar usuário novo em Authentication > Users.
-- Valores válidos de role: admin, requester, executor.

-- João como administrador.
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

-- Exemplo para usuário executor de teste.
-- Altere o e-mail e o nome conforme o usuário criado em Authentication > Users.
update public.profiles
set
  full_name = coalesce(nullif(full_name, ''), 'Executor Teste'),
  role = 'executor',
  active = true,
  updated_at = now()
where lower(email) = lower('seg9@frandolozo.com');

-- Exemplo para usuário solicitante de teste.
-- Descomente e altere quando quiser criar um solicitante.
-- update public.profiles
-- set full_name = 'Solicitante Teste', role = 'requester', active = true, updated_at = now()
-- where lower(email) = lower('email_do_solicitante@empresa.com');

-- Conferência final.
select id, full_name, email, role, active, created_at, updated_at
from public.profiles
order by created_at;
