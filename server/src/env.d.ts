declare namespace NodeJS {
  interface ProcessEnv {
    NODE_ENV: string;
    JWT_SECRET: string;
    CORS_DOMAINS: string;
    REPORTING_API_KEY: string;
    EMAIL_USER: string;
    EMAIL_PWD: string;
    IMAGE_UPLOAD_PATH: string;
    BACKEND_URI: string;
    B2_APPLICATION_ID: string;
    B2_APPLICATION_KEY: string;
    BUCKET_ID: string;
    BUCKET_BASE_URL: string;
  }
}
