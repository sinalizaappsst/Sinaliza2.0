# Sinaliza Web Operacional — Supabase

Esta versão transforma o protótipo HTML do Sinaliza em um sistema de navegador com:

- login real por e-mail e senha no Supabase;
- perfis admin, solicitante e executor;
- base central salva no Supabase;
- evidências enviadas para Supabase Storage;
- publicação simples na Cloudflare sem React/Vite.

## Arquivos principais

- `index.html`: aplicativo Sinaliza.
- `config.js`: URL e anon/publishable key pública do Supabase.
- `supabase_setup.sql`: criação do banco, RLS, perfis e storage.
- `package.json`: build estático simples.
- `wrangler.jsonc`: deploy de assets na Cloudflare Workers & Pages.

## Etapa 1 — Criar banco no Supabase

1. Supabase > SQL Editor > New query.
2. Cole o conteúdo de `supabase_setup.sql`.
3. Antes de executar, confira o e-mail no final do arquivo.
4. Execute.

## Etapa 2 — Configurar chave pública

1. Supabase > Project Settings > Data API/API.
2. Copie o `Project URL`.
3. Copie a `anon public` ou `publishable key`.
4. Abra o arquivo `config.js`.
5. Cole os valores.

Nunca coloque a chave `service_role` no `config.js`.

## Etapa 3 — Publicar na Cloudflare

No GitHub, você pode substituir os arquivos do projeto por estes arquivos.
A estrutura final na raiz deve conter:

- index.html
- config.js
- manifest.json
- sw.js
- package.json
- wrangler.jsonc
- supabase_setup.sql

Na Cloudflare mantenha:

Build command:
`npm run build`

Deploy command:
`npx wrangler deploy`

Root directory:
`/`

Depois faça New deployment.

## Etapa 4 — Criar/confirmar usuário

Supabase > Authentication > Users.
Crie ou confirme seu usuário.
Depois rode novamente no SQL Editor, trocando o e-mail se necessário:

```sql
update public.profiles
set full_name = 'João Gabriel Trindade', role = 'admin', active = true
where lower(email) = lower('SEU_EMAIL_AQUI');
```

## Observação técnica

Esta versão salva o estado operacional em uma linha JSON no Supabase para colocar o sistema para funcionar rápido.
É adequada para piloto controlado. A próxima evolução é migrar para tabelas normalizadas por entidade: operações, clientes, OAEs, evidências, comentários e eventos.
