import B2 from "backblaze-b2";
import { Service } from "typedi";

@Service()
export class BlobService {
  public b2: B2;

  constructor() {
    this.b2 = new B2({
      applicationKey: process.env.B2_APPLICATION_ID,
      applicationKeyId: process.env.B2_APPLICATION_KEY,
    });
  }

  async uploadFile(fileName: string, data: Buffer) {
    console.log("Uploading file to B2");
    await this.b2.authorize();

    let res = await this.b2.getUploadUrl({
      bucketId: process.env.BUCKET_ID,
    });
    let { uploadUrl, authorizationToken }: any = res.data;

    return this.b2.uploadFile({
      uploadUrl,
      fileName: fileName,
      data: data,
      uploadAuthToken: authorizationToken,
    });
  }

  async deleteFile(fileId: string, fileName: string) {
    await this.b2.authorize();
    return this.b2.deleteFileVersion({
      fileId,
      fileName,
    });
  }
}
