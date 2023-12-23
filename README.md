# descolar/descolar-docker-composes-back



## Getting Started

Download links:

SSH clone URL: ssh://git@git.jetbrains.space/3mty/descolar/descolar-docker-composes-back.git

HTTPS clone URL: https://git.jetbrains.space/3mty/descolar/descolar-docker-composes-back.git



These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

## Prerequisites

What things you need to install the software and how to install them.

- For test environment:
```
Download and install Docker Desktop
```

- For production environment:
```
Comming soon
```

## Deployment

⚠️ To deploy this on a production system, you need to contact Matteo. ⚠️

To deploy this on a test system, you need to have the following:

- Execute the docker-compose.yml file, go to the folder where the file is located and run the following command :
``` bash
docker-compose up -d
```

- Download the app for the first time (⚠️ only for the first time ⚠️), run the bash script:
``` bash
docker exec -i Lamp-like bash -c "cd / && sh ./download_src.sh"
```

## Information

The app source will be updated every day at 2pm.

For hot update, you need to run the bash script:
```
Comming soon
```

The source files are located in the folder:
```
In docker: /app/
In local: <your-project>/lamp-like/www/app/
In production: comming soon
```

## Resources

Add links to external resources for this project, such as CI server, bug tracker, etc.
