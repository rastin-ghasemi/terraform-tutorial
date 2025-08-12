![image_alt](https://github.com/rastin-ghasemi/terraform-tutorial/blob/main/Day-15-Azure-Function/README.md.png)
## Azure Functions: Serverless Event-Driven Computing
Azure Functions is Microsoft's serverless compute service that lets you run small pieces of code (functions) in the cloud without managing infrastructure. It automatically scales and charges you only when your code runs.

## 1- Event-Driven Execution
Runs code in response to triggers:

- HTTP requests (build APIs)

- Timers (scheduled tasks)

- Blob Storage changes (new file uploads)

- Queue messages (Azure Queue Storage/Service Bus)

- Database changes (Cosmos DB)

- Event Hub streams (real-time data)

## Serverless
Serverless computing allows developers to build and run applications without managing infrastructure.
- Good for Cost.
- Fast
- There is a server, but we don't worry about it.
## 2. Automatic Scaling
- Instantly scales up/down based on demand

- Can scale to zero when idle (no cost)

- Handles spikes in traffic automatically
## 3. Multiple Language Support
## 4. Flexible Pricing Models
## Common Use Cases
1. **APIs & Microservices**

- Lightweight REST APIs

- Authentication/authorization

2. **File Processing**

- Resize images when uploaded to Blob Storage

- Process CSV/Excel files

3. **Scheduled Tasks**

- Database cleanup every night

- Send daily email reports

4. **IoT & Stream Processing**

- Analyze sensor data from Event Hub

- Real-time notifications

## Develop Azure Functions locally using Core Tools
```bash
https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=linux%2Cisolated-process%2Cnode-v4%2Cpython-v2%2Chttp-trigger%2Ccontainer-apps&pivots=programming-language-csharp
```
- Good Note:
You can deploy(upload) your local function to an Azure function. (We do it in demo) 
## What is a Cold Start?
A cold start is the delay that occurs when a serverless function is invoked after being idle (scaled to zero). During this time:

- The cloud provider must allocate compute resources

- The runtime environment initializes

- Your function code loads

This results in higher latency for the first request after a period of inactivity.

## DEMO Description
First, with the help of rishabkumar7, we have an API that gets URLs and gives us a QR code PNG.
First, we use the core tool to set it up locally and then test it with POSTMAN. The link to the api github is 
```bash
https://github.com/rishabkumar7/azure-qr-code/tree/main
```
After that, we deploy it to Azure function using terraform .
- The blob storage is public to the client, Where others can download PNGs.(So remember that to enable it in Azure)

## Prerequisites

-   [Node.js](https://nodejs.org/)
-   [Azure Functions Core Tools](https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=linux%2Cisolated-process%2Cnode-v4%2Cpython-v2%2Chttp-trigger%2Ccontainer-apps&pivots=programming-language-csharp)
-   Azure CLI
-   An Azure account and an Azure Blob Storage account.

## Create our :
- resource gp (rg.tf)
- storage acc (sa.tf)
- create service plan (service-plan.tf)
- Create function app (func.tf)
takes about 30 minutes to apply.
###
Now we are ready to deploy our app
###
Before that first test, our function API locally
##
1. **cd azure-qr-code/qrCodeGenerator**

2. **npm install**
3. **func init MyProjFolder --worker-runtime Node**
4. **func start**
output:
```bash
Functions:

	GenerateQRCode: [GET,POST] http://localhost:7071/api/GenerateQRCode

```

4. **test**
```bash
curl -X GET https://azure-qr-code.azurewebsites.net/api/GenerateQRCode -H "Content-Type: application/json" -d '{"url":"https://www.example.com"}'
```
###
Now we test the local function, and we have our Azure setup. Let's configure our function to use Azure storage account.
## 5. create local.settings.json
nano local.settings.json
```bash
{
    "IsEncrypted": false,
    "Values": {
        "AzureWebJobsStorage": "",
        "FUNCTIONS_WORKER_RUNTIME": "node",
	      "STORAGE_CONNECTION_STRING":"<YOUR_STORAGE_CONNECTION_STRING>"
    }
}
```
The value of AzureWebJobsStorage and STORAGE_CONNECTION_STRING are in:

azure Portal > rg > storage acc > security + network > access key > 
Copy Connection string

Then fill them.

## 6. Deploy to Azure
Deploy your function app to Azure using the following command:

```bash
func azure functionapp publish <YOUR_FUNCTION_APP_NAME>
```
output:
```bash
rgh@machine:/tmp/t1/azure-qr-code/qrCodeGenerator$ func azure functionapp publish api-func-ghasemi 
Getting site publishing info...
[2025-08-11T17:15:13.459Z] Starting the function app deployment...
Creating archive for current directory...
Uploading 539.56 MB [-----------------------------------------------------------------------------]



#############################################################################]
Upload completed successfully.
Deployment completed successfully.
```
and publish setting only:
```bash
func azure functionapp publish api-func-ghasemi --publish-settings-only
```
output:
```bash
Setting FUNCTIONS_WORKER_RUNTIME = ****
Setting STORAGE_CONNECTION_STRING = ****
```
- Remember you should do both.
## troubleshooting
1. **Go to the function in Azure**
- Deployment Center > logs
2. **Environment variables**
Go to the app settings and check the variables
3. **Don't forget to restart the function**
4. **Development tools in func ssh**
### Some error logs you may face:
```bash
==> functionslogsv2.log <==
4,ee6b2301-c691-4551-8836-1c0551de8b5c,api-func-ghasemi.azurewebsites.net,api-func-ghasemi,,ExecutingHttpRequest,Microsoft.Azure.WebJobs.Script.WebHost.Middleware.SystemTraceMiddleware,"","Executing HTTP request: {   'requestId': '7bd1b816-fc18-4cd5-8059-8d97f47f61c6',   'method': 'GET',   'userAgent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36',   'uri': '/' }",4.1041.200.1,2025-08-12T08:19:26.6856740Z,,"",,,7bd1b816-fc18-4cd5-8059-8d97f47f61c6
4,ee6b2301-c691-4551-8836-1c0551de8b5c,api-func-ghasemi.azurewebsites.net,api-func-ghasemi,,ExecutedHttpRequest,Microsoft.Azure.WebJobs.Script.WebHost.Middleware.SystemTraceMiddleware,"","Executed HTTP request: {   'requestId': '7bd1b816-fc18-4cd5-8059-8d97f47f61c6',   'identities': '',   'status': '200',   'duration': '1' }",4.1041.200.1,2025-08-12T08:19:26.6872401Z,,"",,,7bd1b816-fc18-4cd5-8059-8d97f47f61c6
4,ee6b2301-c691-4551-8836-1c0551de8b5c,api-func-ghasemi.azurewebsites.net,api-func-ghasemi,,ExecutingHttpRequest,Microsoft.Azure.WebJobs.Script.WebHost.Middleware.SystemTraceMiddleware,"","Executing HTTP request: {   'requestId': '24ca2724-eae9-43eb-a214-7ce61f296a6d',   'method': 'POST',   'userAgent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36',   'uri': '/api/GenerateQRCode' }",4.1041.200.1,2025-08-12T08:19:52.5173005Z,,"",,,24ca2724-eae9-43eb-a214-7ce61f296a6d
5,ee6b2301-c691-4551-8836-1c0551de8b5c,api-func-ghasemi.azurewebsites.net,api-func-ghasemi,,GetSecretsEnabled,Microsoft.Azure.WebJobs.Script.WebHost.DefaultSecretManagerProvider,"","SecretsEnabled evaluated to True with type BlobStorageSecretsRepository.",4.1041.200.1,2025-08-12T08:19:52.6544724Z,,"",,,
5,ee6b2301-c691-4551-8836-1c0551de8b5c,api-func-ghasemi.azurewebsites.net,api-func-ghasemi,,,Microsoft.Azure.WebJobs.Script.WebHost.BlobStorageSecretsRepository,"","Sentinel watcher initialized for path /home/data/Functions/secrets/Sentinels",4.1041.200.1,2025-08-12T08:19:52.6723962Z,,"",,,
4,ee6b2301-c691-4551-8836-1c0551de8b5c,api-func-ghasemi.azurewebsites.net,api-func-ghasemi,,CreatedSecretRespository,Microsoft.Azure.WebJobs.Script.WebHost.DefaultSecretManagerProvider,"","Resolved secret storage provider BlobStorageSecretsRepository",4.1041.200.1,2025-08-12T08:19:52.6725133Z,,"",,,
5,ee6b2301-c691-4551-8836-1c0551de8b5c,api-func-ghasemi.azurewebsites.net,api-func-ghasemi,,,Microsoft.Azure.WebJobs.Script.WebHost.SecretManager,"","Loading host secrets",4.1041.200.1,2025-08-12T08:19:52.6768755Z,,"",,,
5,ee6b2301-c691-4551-8836-1c0551de8b5c,api-func-ghasemi.azurewebsites.net,api-func-ghasemi,,,Microsoft.Azure.WebJobs.Script.WebHost.SecretManager,"","Loading secrets for function 'generateqrcode'",4.1041.200.1,2025-08-12T08:19:53.0039154Z,,"",,,
5,ee6b2301-c691-4551-8836-1c0551de8b5c,api-func-ghasemi.azurewebsites.net,api-func-ghasemi,,AuthenticationSchemeNotAuthenticated,Microsoft.Azure.WebJobs.Script.WebHost.Authentication.AuthenticationLevelHandler,"","AuthenticationScheme: WebJobsAuthLevel was not authenticated.",4.1041.200.1,2025-08-12T08:19:53.0597440Z,,"",,11dce872-ba3f-4b3b-bd08-3969c0972390,
5,ee6b2301-c691-4551-8836-1c0551de8b5c,api-func-ghasemi.azurewebsites.net,api-func-ghasemi,,AuthenticationSchemeNotAuthenticated,Microsoft.Azure.WebJobs.Script.WebHost.Security.Authentication.Jwt.ScriptJwtBearerHandler,"","AuthenticationScheme: Bearer was not authenticated.",4.1041.200.1,2025-08-12T08:19:53.1496483Z,,"",,,
4,ee6b2301-c691-4551-8836-1c0551de8b5c,api-func-ghasemi.azurewebsites.net,api-func-ghasemi,GenerateQRCode,FunctionStarted,Function.GenerateQRCode,"","Executing 'Functions.GenerateQRCode' (Reason='This function was programmatically called via the host APIs.', Id=9209714e-7a09-4c64-898d-dd55c295c0ed)",4.1041.200.1,2025-08-12T08:19:53.2418453Z,,"",9209714e-7a09-4c64-898d-dd55c295c0ed,11dce872-ba3f-4b3b-bd08-3969c0972390,24ca2724-eae9-43eb-a214-7ce61f296a6d
4,ee6b2301-c691-4551-8836-1c0551de8b5c,api-func-ghasemi.azurewebsites.net,api-func-ghasemi,,,Worker.LanguageWorkerChannel.node.64914f00-247c-45e8-ab3f-69467c5d3138,"","Worker 64914f00-247c-45e8-ab3f-69467c5d3138 received FunctionInvocationRequest with invocationId 9209714e-7a09-4c64-898d-dd55c295c0ed",4.1041.200.1,2025-08-12T08:19:53.5001940Z,,"",,,
5,ee6b2301-c691-4551-8836-1c0551de8b5c,api-func-ghasemi.azurewebsites.net,api-func-ghasemi,,ChannelReceivedMessage,Worker.LanguageWorkerChannel.node.64914f00-247c-45e8-ab3f-69467c5d3138,"","[channel] received 64914f00-247c-45e8-ab3f-69467c5d3138: InvocationResponse",4.1041.200.1,2025-08-12T08:19:53.5675758Z,,"",,,
5,ee6b2301-c691-4551-8836-1c0551de8b5c,api-func-ghasemi.azurewebsites.net,api-func-ghasemi,,InvocationResponseReceived,Worker.LanguageWorkerChannel.node.64914f00-247c-45e8-ab3f-69467c5d3138,"","InvocationResponse received for invocation: '9209714e-7a09-4c64-898d-dd55c295c0ed'",4.1041.200.1,2025-08-12T08:19:53.5680785Z,,"",,,
4,ee6b2301-c691-4551-8836-1c0551de8b5c,api-func-ghasemi.azurewebsites.net,api-func-ghasemi,GenerateQRCode,FunctionCompleted,Function.GenerateQRCode,"","Executed 'Functions.GenerateQRCode' (Succeeded, Id=9209714e-7a09-4c64-898d-dd55c295c0ed, Duration=438ms)",4.1041.200.1,2025-08-12T08:19:53.6464393Z,,"",9209714e-7a09-4c64-898d-dd55c295c0ed,11dce872-ba3f-4b3b-bd08-3969c0972390,24ca2724-eae9-43eb-a214-7ce61f296a6d
4,ee6b2301-c691-4551-8836-1c0551de8b5c,api-func-ghasemi.azurewebsites.net,api-func-ghasemi,,ExecutedHttpRequest,Microsoft.Azure.WebJobs.Script.WebHost.Middleware.SystemTraceMiddleware,"","Executed HTTP request: {   'requestId': '24ca2724-eae9-43eb-a214-7ce61f296a6d',   'identities': '',   'status': '500',   'duration': '1191' }",4.1041.200.1,2025-08-12T08:19:53.7092485Z,,"",,,24ca2724-eae9-43eb-a214-7ce61f296a6d

==> functionexecutionevents.log <==
84c91e6e-ff3a-4623-9e82-2cee7d085691,api-func-ghasemi,0,GenerateQRCode,9209714e-7a09-4c64-898d-dd55c295c0ed,Finished,459,True,08/12/2025 08:19:53
```
you should check connection string.
