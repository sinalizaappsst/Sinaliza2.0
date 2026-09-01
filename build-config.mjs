const rawUrl = process.env.VITE_SUPABASE_URL || process.env.SINALIZA_SUPABASE_URL || '';
const rawKey = process.env.VITE_SUPABASE_PUBLISHABLE_KEY || process.env.VITE_SUPABASE_ANON_KEY || process.env.SINALIZA_SUPABASE_ANON_KEY || '';

const url = String(rawUrl).trim().replace(/\/$/, '');
const anonKey = String(rawKey).trim().replace(/\s+/g, '');

if (!url || !url.startsWith('https://') || !url.includes('.supabase.co')) {
  console.error('\nERRO: variável VITE_SUPABASE_URL ausente ou inválida.');
  console.error('Use o Project URL do Supabase. Exemplo: https://xxxxxxxxxxxxxxxxxxxx.supabase.co\n');
  process.exit(1);
}

if (!anonKey || anonKey.length < 25) {
  console.error('\nERRO: variável VITE_SUPABASE_PUBLISHABLE_KEY ausente ou inválida.');
  console.error('Use a anon public key / publishable key do Supabase. Não use service_role.\n');
  process.exit(1);
}

const content = `// Arquivo gerado automaticamente no build da Cloudflare.\n// Não coloque service_role aqui.\nwindow.SINALIZA_CONFIG = {\n  url: ${JSON.stringify(url)},\n  anonKey: ${JSON.stringify(anonKey)}\n};\n`;

await import('node:fs/promises').then(fs => fs.writeFile('config.js', content, 'utf8'));
console.log('config.js gerado para:', url);
console.log('Chave pública carregada:', anonKey.slice(0, 12) + '...' + anonKey.slice(-6));
