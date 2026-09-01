# Sinaliza Web Operacional Supabase v2

Esta versão preserva o HTML aprovado da Fase 3.3 e corrige o carregamento da base central do Supabase.

## Correções desta versão

1. Reaplica as extensões da Fase 3/3.1/3.3 depois de carregar os dados do Supabase.
   Isso corrige mapa ao vivo, assistente, checklists avançados, dashboard e painel público.
2. Mantém login real por Supabase.
3. Mantém salvamento central em `sinaliza_app_state`.
4. Mantém evidências preparadas para o bucket `sinaliza-evidences`.
5. Gera `config.js` automaticamente no build da Cloudflare a partir das variáveis.

## Arquivos que devem ficar na raiz do GitHub

- index.html
- package.json
- build-config.mjs
- wrangler.jsonc
- manifest.json
- sw.js
- supabase_setup.sql
- CORRIGIR_USUARIO_E_BASE.sql

O `config.js` é gerado automaticamente pela Cloudflare no build.

## Variáveis obrigatórias na Cloudflare

Em Workers & Pages > sinaliza-app > Settings > Build > Variables and secrets:

- VITE_SUPABASE_URL = Project URL do Supabase, sem `/rest/v1/`
- VITE_SUPABASE_PUBLISHABLE_KEY = anon public key / publishable key

Depois rode **New deployment**.

## SQL obrigatório agora

Execute no Supabase o arquivo:

CORRIGIR_USUARIO_E_BASE.sql

Ele transforma João em administrador e limpa a base antiga/incompleta para o app recriar os dados completos.

## Teste recomendado

1. Faça login com João.
2. Confirme que aparece como Administrador.
3. Abra Mapa ao vivo.
4. Abra Assistente DNIT.
5. Crie uma Nova solicitação.
6. Entre com o usuário executor e veja se a operação aparece em Executar.
