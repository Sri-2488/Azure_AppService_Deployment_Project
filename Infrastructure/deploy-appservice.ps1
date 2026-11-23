
# SriSolutions Australia
# Azure App Service Infrastructure Deployment

$ErrorActionPreference = "Stop"

#configuration
$location = "australiasoutheast"
$rg = "SriSolutions-app-RG"
$plan = "SriSolutions-app-Plan"

#craete a globally unique name for the app service

$app = "tsapp$(Get-Random -Minimum 10000 -Maximum 99999)"

# Azure CLI authentication check

Write-Host  " Checking Azure authentication....." 
$subscriptionId = "3e21cb0d-ba1b-4fa7-9a13-2b7b8fcc65bd"
az account set --subscription $subscriptionId
az account show -o table
if ($LASTEXITCODE -ne 0) {
   
    throw  " Azure authentication failed. Please login to Azure using 'az login' and try again."
}

# Creating Resource Group
Write-Host "Creating Resource Group $rg in $location..." -ForegroundColor Cyan

az group create `
    --name $rg `
    --location $location `
    --output none

if ($LASTEXITCODE -ne 0) {
    throw "Resource Group creation failed. Check Azure CLI errors."
}

# Verifying the Resource Group existence

Write-Host "Verifying Resource Group..." -ForegroundColor Cyan

$rgExists = az group exists --name $rg --output tsv
$verifyExitCode = $LASTEXITCODE

Write-Host "Azure CLI response: [$rgExists]"
Write-Host "Exit code: [$verifyExitCode]"

if ($verifyExitCode -ne 0) {
    throw "Azure CLI failed during Resource Group verification."
}

if ("$rgExists".Trim().ToLowerInvariant() -ne "true") {
    throw "Resource Group does not exist in the selected subscription."
}

Write-Host "Resource Group verified successfully!" -ForegroundColor Green



Write-Host " Creating App Service Plan $plan in $rg..."   -ForegroundColor Green

az appservice plan create `
    --name $plan `
    -g $rg `
    --location $location `
    --sku  F1 `
    --is-linux
if ($LASTEXITCODE -ne 0) {
    throw " App Service Plan creation failed. Please check sku availability and try again."
}



Write-Host " Creating Python web app...."        -ForegroundColor Green

az webapp create `
    --name $app `
    --plan $plan `
    --resource-group $rg `
    --runtime "PYTHON:3.14" 
if ($LASTEXITCODE -ne 0) {
    throw " Web App creation failed. Please check your configuration and try again."
}

Write-Host "Application created successfully!" -ForegroundColor Green

Write-Host " Configuring application settings..."     -ForegroundColor Green

$appSettings = @(
    "ENVIRONMENT=Production"
    "RELEASE_VERSION=2.0.0"
    " SCM_DO_BUILD_DURING_DEPLOYMENT=true"
)

az webapp config appsettings set `
    --name $app `
    -g $rg `
    --settings $appSettings
if ($LASTEXITCODE -ne 0) {
    throw " Application settings configuration failed. Please check your configuration and try again."
}

Write-Host "Application settings configured successfully!" -ForegroundColor Green


Write-Host " Configuring Startup command...."      -ForegroundColor Green

az webapp config set `
    --name $app `
    -g $rg `
    --startup-file " gunicorn --bind=0.0.0.0:8000 --timeout 600 app:app"
if ($LASTEXITCODE -ne 0) {
    throw " Startup command configuration failed. Please check your configuration and try again."
}



Write-Host " Azure Infrastructure Deployment Completed."    -ForegroundColor Green

Write-Host " Web App: $app"     -ForegroundColor Green

Write-host " Resource Group: $rg "   -ForegroundColor Green
