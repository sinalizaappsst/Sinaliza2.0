# Correção do erro Failed to fetch no login

Esta correção faz a Cloudflare gerar o arquivo `config.js` durante o build usando as variáveis configuradas em **Settings > Build > Variables and secrets**.

## Arquivos para enviar ao GitHub

Enviar/substituir na raiz do repositório:

- `package.json`
- `build-config.mjs`

Não envie chave secreta para o GitHub.

## Variáveis necessárias na Cloudflare

Em **Workers & Pages > sinaliza-app > Settings > Build > Variables and secrets**, criar ou conferir:

- `VITE_SUPABASE_URL`
  - valor: Project URL do Supabase, exemplo `https://xxxxxxxxxxxxxxxxxxxx.supabase.co`
  - não usar `/rest/v1/` no final

- `VITE_SUPABASE_PUBLISHABLE_KEY`
  - valor: anon public key / publishable key do Supabase
  - não usar `service_role`
  - colar em uma única linha, sem espaços ou quebras de linha

Depois faça **New deployment**.

## Teste

Depois do deploy, abrir:

`https://sinaliza-app.sinaliza-app-sst.workers.dev/config.js`

O arquivo precisa mostrar a URL correta e uma chave pública preenchida.
