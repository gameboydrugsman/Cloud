#!/bin/sh
echo "Setting environment variables for Terraform"
export ARM_SUBSCRIPTION_ID=aa182816-3611-4bda-bd60-bd10c8928399
export ARM_CLIENT_ID=bb6d394a-4c5b-4ba2-98e1-ba2c312897f2
export ARM_CLIENT_SECRET=eed63ae8-4de7-472b-a7f3-c19787c8fa52
export ARM_TENANT_ID=98932909-9a5a-4d18-ace4-7236b5b5e11d
export ARM_CLIENT_CERTIFICATE_PATH="/path/to/my/client/certificate.pfx"
export ARM_CLIENT_CERTIFICATE_PASSWORD="Pa55w0rd123"

# Not needed for public, required for usgovernment, german, china
export ARM_ENVIRONMENT=public
