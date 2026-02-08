# Patch based instance of Invidious

<div>
  <img src="./screenshots/screenshot1.png" alt="player" width="326"/>
  <img src="./screenshots/screenshot2.png" alt="videos" width="400"/>
</div>

<br/>

Fork of the Invidious project: <https://github.com/iv-org/invidious>

Heavily inspired by the Nerdvpns patched based invidious instance: <https://git.nerdvpn.de/NerdVPN.de/invidious>

Public instances can be found here: <https://redirect.invidious.io/>

## Warning

There is no guarantees that this project will run in your environment. And this project may stop working at any time due to changes in Youtube or invidious itself or just me breaking it.

## Background

To protect my privacy I decided use Invidious but to avoid overloading the public instances I decided to self host my own instance.

## Get started

Before you get started make sure you have red the official documentation: <https://docs.invidious.io/>.

> [!CAUTION]
> Invidious do not proxy videos by default, so if your afraid of revealing your real IP an easy solution is to route the traffic via Gluetun.
>
> Check this guide on how to run Invidious with Gluetun: <https://docs.invidious.io/gluetun/>.
> The project can be found here: <https://github.com/qdm12/gluetun>.

**Initialize the project** (creates .env file and generates secret keys):

```sh
make init
```

> [!IMPORTANT]
> Don't forget to replace DB username and password in the .env file to your liking. Remember that the first time you run docker compose up the username and password will be set for the database so if you decide to change it you'll have to remove your volumes first.

**Build the docker image**:

```sh
make build-image ENV=release    # for production
# or
make build-image ENV=development # for development
```

**Start the containers**:

```sh
make start
```

## Update

```sh
make update
make build-image ENV=release
make start
```

## Available Make Commands

| Command                                       | Description                                       |
| --------------------------------------------- | ------------------------------------------------- |
| `make init`                                   | Initialize project (creates .env, generates keys) |
| `make build-image ENV=[development\|release]` | Build Docker image with patches applied           |
| `make start`                                  | Start Docker containers in background             |
| `make update`                                 | Update submodules from upstream                   |
| `make create-patch`                           | Create patch from changes in submodules           |
| `make create-network`                         | Create Gluetun network                            |
| `make init-db`                                | Initialize database                               |
| `make deploy-database`                        | Deploy database                                   |
| `make message CONTENT="your message"`         | Update banner message                             |
| `make clear-message`                          | Clear banner message                              |
| `make docs`                                   | Show documentation links                          |

## Honorable mentions

If you're interested in privacy respecting Youtube frontends you should also check out the following projects:

- <https://freetubeapp.io/>
- <https://newpipe.net/>
- <https://libretube.dev/>

## Contributing

Contributions are welcome! Please submit pull requests or open issues for any suggestions, bug reports, or improvements.
