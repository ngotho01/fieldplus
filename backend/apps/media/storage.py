from storages.backends.s3boto3 import S3Boto3Storage
from django.conf import settings
import boto3
from botocore.exceptions import ClientError
import logging

logger = logging.getLogger(__name__)


class MinIOStorage(S3Boto3Storage):
    """
    S3-compatible storage using MinIO.
    Auto-creates the bucket if it doesn't exist.
    """
    bucket_name = None  # resolved at init

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.bucket_name = settings.MINIO_BUCKET_NAME
        self._ensure_bucket()

    def _ensure_bucket(self):
        try:
            s3 = boto3.client(
                's3',
                endpoint_url=settings.AWS_S3_ENDPOINT_URL,
                aws_access_key_id=settings.MINIO_ACCESS_KEY,
                aws_secret_access_key=settings.MINIO_SECRET_KEY,
            )
            try:
                s3.head_bucket(Bucket=self.bucket_name)
            except ClientError:
                s3.create_bucket(Bucket=self.bucket_name)
                logger.info('Created MinIO bucket: %s', self.bucket_name)
        except Exception as exc:
            logger.warning('Could not ensure MinIO bucket exists: %s', exc)

    def url(self, name):
        """Return a pre-signed URL valid for 1 hour."""
        return self.connection.meta.client.generate_presigned_url(
            'get_object',
            Params={'Bucket': self.bucket_name, 'Key': self._normalize_name(name)},
            ExpiresIn=3600,
        )