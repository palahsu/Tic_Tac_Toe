# Tic_Tac_Toe
An unbeatable game of Tic Tac Toe. This tic-tac-toe game was developed using Android Studio, the official integrated development environment for Google's Android operating system, designed specifically for Android development. The game itself allows two humans (player X and player O) to compete again each other. The layout is very simple. A 9 square grid, where player X and player O compete against each other. Whenever there is a draw or someone wins, the game displays which player won along with the option to play the game again.

## Features
- Two Player.
- Restart Button.
- Auto Start.

More feature coming soon! This Game is Development Process!
# DevOps Side

# Using AWS Pipeline, Codebuild and S3 to build an android app and deploy it to AppCenter

- Introduction
    - Overview of AWS Pipeline and Codebuild 
- [Pre-requisites](#pre-requisite)
    - [AWS account setup](#setup)
    - [Needed Tokens and informations](#tokens)
- [Provisioning the Infrastructure](#commands)
<a id="pre-requisite"></a>
# **Pre-requisites**

Are you looking to streamline your android app development process? Look no further than AWS Pipeline, Codebuild and S3. These tools offer an efficient and effective way to manage the development process, from building and testing to deployment.

For this tutorial, we will need an AWS account with the following services: 
AWS Codebuild, AWS Pipelines, AWS S3 and AWS Secret Manager.

Moreover, we will need an appcenter account to distribute the application

<a id="setup"></a>
## Setting up AWS

To get started, you'll need to set up an AWS account and have your android application source code ready. Once you have those pre-requisites in place, you can begin creating tokens that you'll later add to your tfvars files to grant access to your github repo.

<a id="tokens"></a>
## Needed Tokens and informations 
Naturally, we will need to create a file filled with variables that will ensure the provisioning when running terraform.
You can copy the tf.vars.example file, change its extansion to tfvars and change the different fields.

You need to create a github personal access token with admin:repo_hook options to trigger the pipeline on each push on the main branch.
The same should be done for the Appcenter account.
More over, you need to choose your AWS Region and a unique name for your S3 bucket. You also need to insert your AWS account id.
Please note that the the contents of your variables.tfvar files should never be publicly shared.

<a id="commands"></a>
# Provisioning the infrastructure
To provision the infrastructure, open the terminal in the ./infra folder and run the following commands:  
``` terraform init ```  
``` terraform apply -var-file=variables.tfvars -auto-approve ```

To destroy the created ressources, just run:   
``` terraform destroy -var-file=variables.tfvars -auto-approve ```  
Note that you'll have to manually delete every file in your S3 bucket before running this command.

If you'll have to provision the infrastructure multiple times, make sure to delete the create key.keystore file