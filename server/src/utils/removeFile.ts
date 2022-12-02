import { existsSync, promises as fs } from "fs"
import logger from "./logger"

export const removeFile = async (filePath: string) => {
    try {
        if (existsSync(filePath)) {
            await fs.unlink(filePath)
        }
    }
    catch (error) {
        logger.error('Error removing file:' + filePath)
    }
}