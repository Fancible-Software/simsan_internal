declare namespace NodeJS {
  interface ProcessEnv {
    NODE_ENV: string;
    JWT_SECRET: string;
    CORS_DOMAINS: string;
    REPORTING_API_KEY: string;
    EMAIL_USER: string;
    EMAIL_PWD: string;
  }
}
