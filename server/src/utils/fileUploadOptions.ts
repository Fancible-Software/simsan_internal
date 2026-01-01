import multer, { Options } from "multer"
import path from "path"
import { existsSync, mkdirSync } from "fs"
import { APIError } from "./APIError";

// Get upload path from environment or use default
const getUploadPath = (): string => {
    const uploadPath = process.env.IMAGE_UPLOAD_PATH || "../../public/uploads";
    const fullPath = path.join(__dirname, uploadPath);
    
    // Ensure directory exists
    if (!existsSync(fullPath)) {
        mkdirSync(fullPath, { recursive: true });
    }
    
    return fullPath;
};

export const fileUploadOptions: Options = {
    storage: multer.diskStorage({
        destination: getUploadPath(),
        filename: (_, file, cb) => {
            cb(null, `${Date.now()}_${file.originalname}`);
        }
    }),
    fileFilter: async (_req, file, cb) => {
        console.log(file.mimetype)
        if (file.mimetype === "image/png" || file.mimetype === "image/jpeg" || file.mimetype === "image/jpg") {
            return cb(null, true)
        }
        return cb(new APIError('Only image allowed!', 400))
    },
    limits: {
        files: 1,
        fieldNameSize: 255,
        fileSize: 1024 * 1024 * 80
    },
}