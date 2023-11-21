import { Controller, Res, UploadedFile, Post } from "routing-controllers";
// import { BlobService } from "../services/BlobService";
import { Response } from "express";
import { ResponseStatus } from "../types";
import { Inject, Service } from "typedi";
import { BlobService } from "../services/BlobService";

@Service()
@Controller("/blob")
export class BlobController {
  constructor(
    @Inject()
    private blobService: BlobService
  ) {}

  @Post("/upload")
  async uploadFile(@UploadedFile("file") file: any, @Res() res: Response) {
    try {
      console.log("uploading file");
      const uploadFile = await this.blobService.uploadFile(
        file.originalname,
        file.buffer
      );
      
      if (uploadFile) {
        res.status(ResponseStatus.SUCCESS_FETCH).send({
          status: true,
          data: {
            fileId: uploadFile.data.fileId,
            fileName: uploadFile.data.fileName,
            imageUrl: `${process.env.BUCKET_BASE_URL}${uploadFile.data.fileId}`,
          },
        });
      }
      res.status(ResponseStatus.FAILED_UPDATE).send({
        status: false,
      });
    } catch (error) {
      console.log(error);
      res.status(ResponseStatus.API_ERROR).send({
        status: false,
        message: error.message,
      });
    } finally {
      return res;
    }
  }
}
