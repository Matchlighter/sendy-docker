# Sendy Docker Image

This repository contains a Dockerfile and supporting configuration to run [Sendy](https://sendy.co) in Docker.

# Usage
1. Download Sendy and extract it to `./sendy`. (So that `./sendy` has an `index.php` file)
2. Run `docker build . -t sendy`
3. Copy `sample.env` to just `.env` and modify the variables appropriately.
4. Run `docker run -p 80:80 -v ./data/uploads:/var/www/html/uploads --env-file .env sendy`

## Configuration
Configuration is completed via ENV variables. They should either align with the params in Sendy's `config.php` or be documented in `sample.env`.

## Docker Compose
This image can be used with Docker Compose and a __partial__ `docker-compose.sample.yml` file is provided but incomplete (Contributions welcome).

# Contributors
- Some snippets were used from https://github.com/hardware/mailserver (Thanks!)

# License
The contents of this repository are licensed under the terms of the MIT License.
Sendy is licensed under the terms expressed and noted on the official website, [Sendy.co](https://sendy.co).
Because of Sendy's proprietary licensing, it will not be included in the repository and should be download separately.
For that reason, the resulting Docker images should not be uploaded to a public registry such as Docker Hub.
