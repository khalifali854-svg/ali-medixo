/// Central Environment & API Configuration for App Ali
class AppConfig {
  // Supabase Backend Credentials
  static const String supabaseUrl = 'https://sagnmquiewnypuplhxhs.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNhZ25tcXVpZXdueXB1cGxoeGhzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODgxMjE4NTYsImV4cCI6MjEwMzY5Nzg1Nn0.i_R891cXOOMW28SKNAtbhXtKI3Jf0tq4AhiyZLmfiqk';

  // Google OAuth Web Client ID
  static const String googleWebClientId =
      '1049453517216-98v4k5q65eq7e0e7a9cph6v2mko3ldeb.apps.googleusercontent.com';

  // Cloudflare R2 Storage Configuration (bucket: ali-app)
  static const String r2AccountId = 'f7e27ce0b4c2e9e41ad1dfcbb89bc5b3';
  static const String r2Endpoint = 'https://f7e27ce0b4c2e9e41ad1dfcbb89bc5b3.r2.cloudflarestorage.com';
  static const String r2BucketName = 'ali-app';
  static const String r2AccessKey = 'f5312c9a802d364507bae5ad7872cf7c';
  static const String r2SecretKey = '9ddd94fe9a0c875abfaf3d2074284a4320803b90904f9612ab320d57adde5491';

  // Public Asset CDN Domain (R2 dev public domain for bucket ali)
  static const String r2PublicBaseUrl = 'https://ali.medixo.id';

  // Cloudflare API Token
  static const String cloudflareAiToken = 'cfat_RSjHLezoB3m8ljvRwMLXkvDJzuPzYzKIEDiUCxycb954b5c8';
}
