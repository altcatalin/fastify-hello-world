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
pre-commit install --install-hooks -t commit-msg
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
