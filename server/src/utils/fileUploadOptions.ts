import multer, { Options } from "multer"
import path from "path"
import { APIError } from "./APIError";

export const fileUploadOptions: Options = {
    storage: multer.diskStorage({
        destination: path.join(__dirname, process.env.IMAGE_UPLOAD_PATH),
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