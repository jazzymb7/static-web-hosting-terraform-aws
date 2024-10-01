# AWS S3 Static Website Hosting using Terraform

This project sets up an AWS S3 bucket for hosting a static website using Terraform. The bucket is configured to allow public read access and serves the `index.html` file as the default document. The project is designed to automatically generate a unique bucket name and upload static files from the `html` directory.

## Prerequisites

Before deploying this infrastructure, ensure you have the following tools installed on your machine:

1. **Terraform**: Install Terraform by following the instructions on the [Terraform website](https://www.terraform.io/downloads.html).
2. **AWS CLI**: Configure the AWS CLI with proper access using `aws configure` or ensure you have your credentials in `~/.aws/credentials`.

## Resources Created

- **S3 Bucket**: A new S3 bucket is created with a random suffix.
- **Bucket Ownership Control**: Configured to prefer bucket ownership for objects.
- **Bucket Policy**: A bucket policy is applied to allow public read access.
- **Website Configuration**: The bucket is configured for static website hosting with `index.html` and `error.html`.
- **Bucket ACL**: The bucket is granted `public-read` access to allow public users to access the website.
- **Public Access Block**: Configured to allow public access policies.
- **S3 Objects**: Files from the `html/` folder are uploaded to the bucket.

## File Structure

```plaintext
.
├── html
│   ├── index.html
│   └── error.html
├── main.tf
└── README.md
