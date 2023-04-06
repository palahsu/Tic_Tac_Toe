# Tic_Tac_Toe
An application developed by <a href="https://github.com/palahsu">Palahsu</a> and the infrastracture provisioned by myself using AWS services.  

An unbeatable game of Tic Tac Toe. This tic-tac-toe game was developed using Android Studio, the official integrated development environment for Google's Android operating system, designed specifically for Android development. The game itself allows two humans (player X and player O) to compete again each other. The layout is very simple. A 9 square grid, where player X and player O compete against each other. Whenever there is a draw or someone wins, the game displays which player won along with the option to play the game again.

## Features
- Two Player.
- Restart Button.
- Auto Start.

More feature coming soon! This Game is Development Process!

For any kind of help, support, payment, suggestion and request ask me on Gmail / Telegram:

<a href="https://t.me/CyberClans"><img src="https://img.shields.io/badge/Telegram-Group%20Telegram%20Join-blue.svg?logo=telegram"></a>

## Follow on:
<p align="left">
<a href="https://github.com/palahsu"><img src="https://img.shields.io/badge/GitHub-Follow%20on%20GitHub-inactive.svg?logo=github"></a>
</p><p align="left">
<a href="https://www.facebook.com/aduri.knox01/"><img src="https://img.shields.io/badge/Facebook-Follow%20on%20Facebook-blue.svg?logo=facebook"></a>
</p><p align="left">
<a href="https://t.me/AD0000000"><img src="https://img.shields.io/badge/Telegram-Contact%20Telegram%20Profile-blue.svg?logo=telegram"></a>
</p><p align="left"> 

# DevOps Side

# Using AWS Pipeline, Codebuild and S3 to build an android app and deploy it to AppCenter

- Introduction
    - Overview of AWS Pipeline, Codebuild and S3
- Pre-requisites
    - AWS account setup
    - Android application source code
- Setting up AWS S3
    - Creating a bucket
    - Configuring the bucket
- Setting up AWS Pipeline
    - Creating a pipeline
    - Configuring the pipeline
- Setting up AWS Codebuild
    - Creating a build projec
- Uploading the android application package to AppCenter
- Running the pipeline to build and deploy the android APP
- Conclusion

# **Pre-requisites**

Are you looking to streamline your android app development process? Look no further than AWS Pipeline, Codebuild and S3. These tools offer an efficient and effective way to manage the development process, from building and testing to deployment.

For this tutorial, we will need an AWS account with the following services: 
AWS Codebuild, AWS Pipelines, AWS S3 and AWS Secret Manager.

Moreover, we will need an android application that we will build and deploy later on. The application used in this example is a java application build by Gradle and stored as an APK

# Setting up AWS S3

To get started, you'll need to set up an AWS account and have your android application source code ready. Once you have those pre-requisites in place, you can begin setting up your AWS Pipeline. This involves creating a pipeline and configuring it to include the necessary build and deployment steps.

First, you'll set up AWS S3 to store your android application package and files. This involves creating a bucket and configuring it to allow for easy and secure access to your app package. Once your app package is uploaded to S3, you can run the pipeline to build and deploy your android app to AppCenter.

But before moving to that step, we first need to create a keystore and store it in the s3 bucket.

Use this command:

```
keytool -genkey -v -keystore <keystore_name>.jks -keyalg RSA -keysize 2048 -validity 10000 -alias <alias_name>
```

A prompt will open and you’ll need to enter two passwords. Keep track of these passwords as you will need them later to sign your application.

Now store the generated file in your s3 bucket at a specific location and add a policy that’ you’ll assign later to your codeBuilds so they can access the bucket’s content.

# Setting up AWS Pipeline

To continue setting up AWS Pipeline, you'll need to create a pipeline and configure it to include the necessary build and deployment steps. This involves defining the source location, the build environment, and the deployment destination for your android app. 
For the source location, I used a Github repository and granted authorizations to use webhooks and notify the AWS agent to trigger the pipeline on each push on the main branch.

To make sure the pipeline is working right, we need to set up at least a build or deploy stage and create an appropriate role.

For this example we’re using 3 stages:

- The first default stage which is automatically set up. This stage is just getting the code from the source and adding it to the s3 bucket in a compressed format. CodePipeline makes sure to pass those created artifacts / compressed files to the next phase.
- The second stage will be responsible of building the application from the source code and pass the apk file to the next stage.
- The third and last stage will be responsible of connecting to appcenter and deploying the application.

# Setting up AWS Codebuild

Part of setting up the codebuild is giving the necessary access to each code build and choose the right version that supports the right version of java/node/ or whatever language you are using.
In this part,  

Next, you'll set up AWS Codebuild, which allows you to create a build project and configure it to use the specific tools and resources needed for your app. With Codebuild, you can also specify custom build commands and scripts to ensure your app is built exactly how you want it

The benefits of using AWS Pipeline, Codebuild and S3 are many. By automating the build and deployment process, you can save time and reduce errors. And with the scalability and flexibility of AWS services, you can easily customize and expand your development process as needed.