This automation shell script performs the following steps:

Task 2

1. It Updates the package list. 
2. It will installs apache2, if there is no apache2 installed earlier.
3. It checks if apache2 is running or not, then it starts the service.
4. Checks if apache2 is enabled or not, then it enables it.
5. Create a tar archive of apache2 access and error logs
6. Uploads the compressed file to the AWS s3 bucket
