from flask import Flask, request, render_template  # Import Flask and necessary functions for handling HTTP requests and rendering templates
import os  # Import os module for environment variable access
from azure.storage.blob import BlobServiceClient  # Import Azure Blob Service client for blob storage operations
from azure.keyvault.secrets import SecretClient  # Import SecretClient for accessing secrets from Azure Key Vault
from azure.identity import DefaultAzureCredential  # Import DefaultAzureCredential for Azure authentication

# Initialize Flask app
app = Flask(__name__)  # Create a new Flask web application instance

# Azure Key Vault configuration
keyVaultName = os.environ["KEY_VAULT_NAME"]  # Retrieve the Key Vault name from environment variables
KVUri = f"https://{keyVaultName}.vault.azure.net"  # Construct the Key Vault URI

credential = DefaultAzureCredential()  # Create a DefaultAzureCredential instance for authentication
client = SecretClient(vault_url=KVUri, credential=credential)  # Create a SecretClient instance to interact with Azure Key Vault

# Retrieve the Blob Storage connection string from Key Vault
secretName = os.environ["SECRET_NAME"]  # Retrieve the secret name from environment variables
retrieved_secret = client.get_secret(secretName)  # Get the secret value from Key Vault
connect_str = retrieved_secret.value  # Extract the connection string from the retrieved secret

# Blob Storage container configuration
container_name = os.environ["CONTAINER_NAME"]  # Retrieve the container name from environment variables
blob_service_client = BlobServiceClient.from_connection_string(conn_str=connect_str)  # Create a BlobServiceClient instance with the connection string

# Get or create container client
try:
    container_client = blob_service_client.get_container_client(container=container_name)  # Get a client for the specified container
    container_client.get_container_properties()  # Attempt to retrieve container properties to check if it exists
except Exception as e:  # If an exception occurs (e.g., container not found)
    print("Container not found. Creating new container.")  # Print a message indicating that the container will be created
    container_client = blob_service_client.create_container(container_name)  # Create a new container if it does not exist

@app.route("/")  # Define the route for the root URL
def view_photos():
    return render_template('index.html')  # Render the 'index.html' template for the root URL

@app.route("/upload-photos", methods=["POST", "GET"])  # Define the route for file uploads, allowing both GET and POST methods
def upload_photos():
    filenames = ""  # Initialize a variable to store filenames of uploaded files
    img_html = ""  # Initialize a variable to store HTML for displaying file links

    if request.method == "POST":  # Check if the request method is POST
        for i, file in enumerate(request.files.getlist("photos")):  # Iterate over the list of uploaded files
            try:
                blob_client = container_client.upload_blob(file.filename, file, overwrite=True)  # Upload the file to Azure Blob Storage
                filenames += file.filename + "<br />"  # Append the filename to the filenames string
                img_html += (
                    f"<p>Link: <a id='link{i}' href='{blob_client.url}' target='_blank'>{blob_client.url}</a> "
                    f"<button class='btn btn-sm btn-outline-secondary ml-2' onclick='copyToClipboard(\"link{i}\")'>Copy Link</button></p>"
                )  # Append HTML for the file link and a button to copy the link to the clipboard
            except Exception as e:  # If an exception occurs during file upload
                print(e)  # Print the exception details
                print("Ignoring duplicate filenames")  # Print a message indicating that duplicate filenames are ignored

    return render_template("uploaded_files.html", filenames=filenames, img_html=img_html)  # Render the 'uploaded_files.html' template with filenames and image HTML

if __name__ == "__main__":  # Check if the script is being run directly
    app.run(debug=True)  # Start the Flask development server in debug mode
