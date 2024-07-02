# CLOUD UPLOADER TOOL

## Overview

This script, `cloudup`, is designed to manage Azure Blob storage operations including:

- Listing blobs
- Uploading files
- Generating shareable links for blobs
- Downloading files from the blob storage

## Prerequisites

1.  **Azure CLI**: Ensure that Azure CLI is installed and configured on your system. You can download and install it from [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
2.  **Azure Storage Account Key**: Set the environment variable `AZURE_STORAGE_KEY` with your Azure Storage Account Key.

## Configuration

The script requires configuration of the following variables:

- `storageAccount`: Name of your Azure storage account.
- `containerName`: Name of the container in your Azure Blob storage.
- `permissions`: Permissions for the SAS token.
- `expiry`: Expiry time for the SAS token.

## Installation

To make the `cloudup` script executable system-wide on a Linux system, follow these steps:

1.  **Move the script to `/usr/local/bin`**:

    bash

    Copy code

    `sudo mv ./cloudup /usr/local/bin/cloudup`

    This command moves the `cloudup` script to the `/usr/local/bin` directory, which is typically included in the PATH for all users.

2.  **Make the script executable**:

    bash

    Copy code

    `sudo chmod +x /usr/local/bin/cloudup`

    This command makes the script executable by setting the appropriate permissions.

3.  **Verify the script is in the PATH**:

    bash

    Copy code

    `echo $PATH`

    Ensure that `/usr/local/bin` is included in the output. If not, you may need to add it to your PATH.

4.  **Run the script from anywhere**:

    You should now be able to run the script from any location using the following command:

    `cloudup`

## Usage

The script supports the following operations:

1.  **Listing Blobs**

    `cloudup -l`

    Lists all the blobs in the specified container.

2.  **Uploading a File**

    `cloudup -u <filename>`

    Uploads the specified file to the Azure Blob storage. If the file is successfully uploaded, you will be prompted to generate a shareable link.

3.  **Generating a Shareable Link**

    `cloudup -s <filename>`

    Generates a shareable link for the specified file in the blob storage.

4.  **Downloading a File**

    `cloudup -d <filename>`

    Downloads the specified file from the Azure Blob storage to the local machine.

## Help

To display the help message:

`cloudup`

## Example

1.  **Uploading a File and Generating a Shareable Link**

    `cloudup -u example.txt`

    After uploading, you will be prompted:

    `Do you want to generate the link for example.txt (y/n): y`

    If you choose `y`, the script will generate the shareable link.

2.  **Listing Blobs**

    `cloudup -l`

3.  **Generating a Shareable Link for an Existing Blob**

    `cloudup -s example.txt`

4.  **Downloading a File**

    `cloudup -d example.txt`

## Notes

- Ensure that the environment variable `AZURE_STORAGE_KEY` is set with your Azure Storage Account Key before running the script.
- The script checks if the file exists and is not empty before attempting to upload.
- The script generates a SAS token with `rwl` permissions and a 30-minute expiry for generating shareable links.
