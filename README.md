# Fastify Hello World

Simple REST API with [Fastify](https://fastify.dev/) web framework.

# Development

[Semantic Versioning](https://semver.org/) and [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specifications are enforced in this repository.  
`main` branch is protected and changes must be merged via pull requests.

Clone the project.

```shell
  git clone git@github.com:altcatalin/fastify-hello-world.git
```

Go to the project directory.

```shell
  cd fastify-hello-world
```

Install [pre-commit](https://pre-commit.com/#install). Check [pre-commit](https://pre-commit.com/#install) documentation for other options.

```shell
pip install pre-commit
pre-commit --version
```

Set up the git hook scripts.

```shell
pre-commit install
```

Install dependencies

```shell
npm install
```

(VS Code only) Install VS Code extensions: [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint), [Prettier ESLint](https://marketplace.visualstudio.com/items?itemName=rvest.vs-code-prettier-eslint) and [EditorConfig](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig).

Run unit tests

```shell
npm run test
```

Start web server

```shell
npm run server
```

# Build Azure Image

Create resource group

```shell
az group create -n fastify-hello-world --location germanywestcentral
```

Create service principal

```shell
# !!! Save the content of $AZURE_SECRETS in safe place for long-term storage
AZURE_SECRETS=$(az ad sp create-for-rbac -n "$USER@$(hostname -f)" --role Contributor --scopes /subscriptions/$(az account show --query "{ subscription_id: id }" | jq -r ".subscription_id") --query "{ client_id: appId, client_secret: password, tenant_id: tenant }")
```

Build image

```shell
packer init image.pkr.hcl

packer build \
  -var "subscription_id=$(az account show --query "{ subscription_id: id }" | jq -r ".subscription_id")" \
  -var "tenant_id=$(echo $AZURE_SECRETS | jq -r ".tenant_id")" \
  -var "client_id=$(echo $AZURE_SECRETS | jq -r ".client_id")" \
  -var "client_secret=$(echo $AZURE_SECRETS | jq -r ".client_secret")" \
  -var "version=sha-$(git rev-parse --short HEAD)" \
  image.pkr.hcl
```
