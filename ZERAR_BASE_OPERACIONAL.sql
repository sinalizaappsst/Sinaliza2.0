-- SINALIZA - ZERAR INFORMAÇÕES DE DEMONSTRAÇÃO
-- Execute no Supabase > SQL Editor > New query, depois de publicar a versão v3.
-- Mantém usuários do Supabase, perfis, estrutura, clientes, OAEs, mapa e checklists.
-- Remove operações, histórico, chats e evidências da base central JSON.

-- 1) Zera a base operacional central.
-- No próximo login, o app recria o estado estrutural limpo, sem operações de demonstração.
delete from public.sinaliza_app_state
where id = '00000000-0000-4000-8000-000000000001'::uuid;

-- 2) Opcional: remove registros de arquivos do bucket de evidências.
-- Use apenas se quiser limpar evidências de teste já enviadas.
-- delete from storage.objects where bucket_id = 'sinaliza-evidences';

-- 3) Conferência: não deve retornar nenhuma linha para a base central.
select *
from public.sinaliza_app_state
where id = '00000000-0000-4000-8000-000000000001'::uuid;
