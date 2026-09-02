# Sinaliza Web Operacional Supabase v3

Esta versão remove a ação **Restaurar demonstração** da interface e inicia a base operacional sem dados fictícios.

## Arquivos para subir no GitHub

Substitua/envie todos os arquivos desta pasta na raiz do repositório:

- `index.html`
- `config.js`
- `package.json`
- `build-config.mjs`
- `wrangler.jsonc`
- `manifest.json`
- `sw.js`
- `supabase_setup.sql`
- `AJUSTAR_PERFIS_USUARIOS.sql`
- `ZERAR_BASE_OPERACIONAL.sql`

## Depois do deploy

No Supabase, execute:

1. `AJUSTAR_PERFIS_USUARIOS.sql` para definir João como admin e configurar perfis de teste.
2. `ZERAR_BASE_OPERACIONAL.sql` para limpar operações, histórico, chats e evidências de demonstração.

## Como criar novos usuários nesta etapa

1. Supabase > Authentication > Users > Add user.
2. Crie o usuário com e-mail e senha.
3. Marque Auto Confirm User, se aparecer.
4. Execute `AJUSTAR_PERFIS_USUARIOS.sql` ajustando o e-mail e o role.

Nesta versão, por segurança, a criação real de usuário ainda é feita pelo Supabase Dashboard. O app lê o perfil do usuário e libera o menu conforme `role`:

- `admin`: Dashboard, mapa, agenda, solicitações, histórico, conversas, assistente e administração.
- `requester`: nova solicitação, minhas solicitações, conversas, assistente e histórico.
- `executor`: execução, agenda, conversas, assistente e concluídas.

Não coloque `service_role` no navegador.
