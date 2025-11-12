import { S3Client, PutObjectCommand, GetObjectCommand, ListObjectsV2Command, DeleteObjectCommand } from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";

class S3Service {
  constructor({ region, accessKeyId, secretAccessKey, bucketName }) {
    this.bucketName = bucketName;
    this.s3Client = new S3Client({
      region,
      credentials: {
        accessKeyId,
        secretAccessKey,
      },
    });
  }

  async uploadFile(file, key) {
    try {
      const uploadParams = {
        Bucket: this.bucketName,
        Key: key,
        Body: file,
        ContentType: file.type,
        ContentDisposition: 'attachment',
      };

      const command = new PutObjectCommand(uploadParams);
      await this.s3Client.send(command);
      console.log("FOI!");
    } catch (error) {
      console.error("Error uploading file:", error);
      throw new Error("File upload failed");
    }
  }

  async listFiles(prefix) {
    try {
      const params = {
        Bucket: this.bucketName,
        Prefix: prefix,
      };
      const command = new ListObjectsV2Command(params);
      const data = await this.s3Client.send(command);
      return data.Contents || [];
    } catch (error) {
      console.error("Error listing files:", error);
      throw new Error("Error listing files");
    }
  }

  async getFileUrl(key) {
    try {
      const command = new GetObjectCommand({
        Bucket: this.bucketName,
        Key: key,
        ResponseContentDisposition: 'attachment',
      });

      const signedUrl = await getSignedUrl(this.s3Client, command, { expiresIn: 600 });
      return signedUrl;
    } catch (error) {
      console.error("Error getting file URL:", error);
      throw new Error("Error fetching file URL");
    }
  }

  async deleteFile(key) {
    try {
      const command = new DeleteObjectCommand({
        Bucket: this.bucketName,
        Key: key,
      });
      await this.s3Client.send(command);
      console.log("File deleted successfully");
    } catch (error) {
      console.error("Error deleting file:", error);
      throw new Error("Error deleting file");
    }
  }
}

export default S3Service;