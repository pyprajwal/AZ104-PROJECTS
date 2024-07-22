# FileShare Application

## Overview

This Flask application allows users to upload files to Azure Blob Storage. The application provides a simple interface for selecting and uploading multiple files, and displays the results with links to the uploaded files. Users can also copy the links to the clipboard for easy sharing.

## Features

- **File Upload**: Upload multiple files to Azure Blob Storage.
- **Display Results**: View a list of uploaded files with links.
- **Copy Links**: Copy file links to the clipboard with a single click.
- **Responsive Design**: User-friendly interface with Bootstrap styling.

## Setup and Configuration

### Prerequisites

- **Python 3.x**: Ensure Python 3.x is installed.
- **Flask**: Web framework for building the application.
- **Azure SDK**: Libraries for interacting with Azure Blob Storage and Key Vault.

### Environment Variables

Set the following environment variables for configuration:

- `KEY_VAULT_NAME`: Name of your Azure Key Vault.
- `SECRET_NAME`: Name of the secret that contains the Azure Blob Storage connection string.
- `CONTAINER_NAME`: Name of the container in Azure Blob Storage where files will be stored.

### Installation

1.  **Clone the Repository**:

        `git clone <repository-url>

    cd <repository-directory>`

2.  **Install Dependencies**:

    `pip install -r requirements.txt`

3.  **Run the Application Locally**:

    `flask run`

    The application will be accessible at `http://localhost:5000`.

### Deploy to Azure Web App Service

1.  **Create a Web App Service in Azure**: Follow the [Azure documentation](https://docs.microsoft.com/en-us/azure/app-service/quickstart-python) to create a new Web App Service.

2.  **Deploy Your Application**:

    - **Using Git**: Push your code to the Azure Web App repository.
    - **Using Azure CLI**:

      `az webapp up --name <app-name> --resource-group <resource-group>`

3.  **Configure Environment Variables**:

    - Go to the Azure portal.
    - Navigate to your Web App Service.
    - Under "Settings", select "Configuration" and add the required environment variables as listed above.
    - and add `SCM_DO_BUILD_DURING_DEPLOYMENT` set its value to 1. This variable instructs Azure to build your application during the deployment phase.

## Application Structure

- **`app.py`**: Main application file containing Flask routes and Azure Blob Storage integration.
- **`templates/`**: Directory containing HTML templates for the application.
  - **`index.html`**: File upload form.
  - **`uploaded_files.html`**: Results page displaying uploaded files and links.
- **`static/`**: Directory for static files such as CSS and JavaScript.

## Acknowledgements

- **Flask**: Micro web framework used for building the application.
- **Bootstrap**: Framework used for styling the HTML templates.
- **Azure SDK**: Libraries for interacting with Azure ser
