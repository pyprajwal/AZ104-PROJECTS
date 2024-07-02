#!/bin/bash

# Script for managing Azure Blob storage operations:
# - Listing blobs
# - Uploading files
# - Generating shareable links for blobs

# Azure storage account and container configuration
storageAccount="cloudeuploader"
containerName="uploadfromlinux"
permissions="rwl"
expiry=$(date -u -d "30 minutes" '+%Y-%m-%dT%H:%MZ')

# Function to display help message
function show_help {
    echo "------------------------------------------------------------------------------"
    echo "To list files in cloud => $0 -l"
    echo "To upload file to cloud => $0 -u <filename>"
    echo "To get a shareable link for the file in cloud => $0 -s <filename>"
    echo "To download a file from the cloud => $0 -d <filename>"
    echo "------------------------------------------------------------------------------"
}

function uploadBlob {
    getfullpathfile=$(readlink -f "$2")  # Get the full path of the file
    filename=$(basename "$2")  # Get the file name from the full path
    # Upload the file to Azure Blob storage
    az storage blob upload \
        --name "$filename" \
        --file "$getfullpathfile" \
        --container-name "$containerName" \
        --account-name "$storageAccount" \
        --account-key "$AZURE_STORAGE_KEY" > /dev/null

    if [ $? -eq 0 ]; then
        echo "------------------------------------------------------------------------------"
        echo "File $filename uploaded successfully."
        echo "------------------------------------------------------------------------------"
    else
        echo "------------------------------------------------------------------------------"
        echo "ERROR: Failed to upload file $filename."
        echo "------------------------------------------------------------------------------"
    fi
}

function generateShareLink {
    # Generate a shareable link for a blob
    blobList=$(az storage blob list \
        --container-name "$containerName" \
        --account-name "$storageAccount" \
        --account-key "$AZURE_STORAGE_KEY" \
        --output table | grep -i "$2")  # Check if the file exists in the blob list
    
    if [ -z "$blobList" ]; then
        echo "------------------------------------------------------------------------------"
        echo "ERROR: $2 file not found in Blob storage."
        echo "------------------------------------------------------------------------------"
    else
        echo "------------------------------------------------------------------------------"
        echo "$2 found in Blob storage."
        # Generate SAS token for the container
        blobSASToken=$(az storage container generate-sas \
            --name "$containerName" \
            --https-only \
            --permissions "$permissions" \
            --expiry "$expiry" \
            --account-key "$AZURE_STORAGE_KEY" \
            --account-name "$storageAccount" | tr -d '"')
        
        # Create the shareable link
        shareLink="https://${storageAccount}.blob.core.windows.net/${containerName}/${2}?${blobSASToken}"
        echo "------------------------------------------------------------------------------"
        echo "LINK FOR THE FILE $2: $shareLink"
        echo "------------------------------------------------------------------------------"
    fi
}

function listBlob {
    # List blobs in the container
    az storage blob list \
        --container-name "$containerName" \
        --account-name "$storageAccount" \
        --account-key "$AZURE_STORAGE_KEY" \
        --output table  # Display output in table format
}

function downloadBlob {
    az storage blob download \
        --container-name "$containerName" \
        --file "$2" \
        --name "$2" \
        --account-name "$storageAccount" \
        --account-key "$AZURE_STORAGE_KEY" > /dev/null
    
    if [ $? -eq 0 ]; then
        echo "------------------------------------------------------------------------------"
        echo "File $2 downloaded successfully."
        echo "------------------------------------------------------------------------------"
    else
        echo "------------------------------------------------------------------------------"
        echo "ERROR: Failed to download file $2. The specified blob does not exist."
        echo "------------------------------------------------------------------------------"
    fi
}

# Check if any arguments are provided
if [ "$#" -eq 0 ]; then
    show_help
    exit 1
fi

# Main case statement to handle different operations
case $1 in
    -u)
        # Upload file to blob storage
        if [ -f "$2" ]; then # Check if the file exists
            if [ -s "$2" ]; then # Check if the file is not empty
                uploadBlob "$@"
                echo "------------------------------------------------------------------------------"
                echo "File Found: $2"
                echo "------------------------------------------------------------------------------"
                read -p "Do you want to generate the link for ${2} (y/n): " needLink
                if [ "$needLink" == "y" ]; then
                    generateShareLink "$@"
                fi
            else
                echo "------------------------------------------------------------------------------"
                echo "$2 is an empty file."
                echo "------------------------------------------------------------------------------"
            fi
        else
            echo "------------------------------------------------------------------------------"
            echo "$2: ERROR: File not found."
            echo "------------------------------------------------------------------------------"
        fi
        ;;
    -l)
        listBlob
        ;;
    -s)
        generateShareLink "$@"
        ;;
    -d)
        downloadBlob "$@"
        ;;
    *)
        # Display help message if the provided option is invalid
        show_help
        ;;
esac
