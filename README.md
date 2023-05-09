# VPM Registry

This is an **experiment** to create a VRChat Package Manager (VPM) registry, developed using the [Bullet Train](https://bullettrain.co/) Ruby on Rails SaaS Framework.

## Why?

Because I thought it might be a fun experiment.

VRChat has already explicitly stated their [intentions to host community packages](https://vcc.docs.vrchat.com/vpm/packages/#community-packages) in the future.

As such, this project is expected to have a limited lifespan, *is not developed with battle-tested production-readiness in mind*, and will likely be deprecated as soon as VRChat releases their official community package host.

## Development

1. You must have the following dependencies installed:

     - Ruby 3
          - See [`.ruby-version`](.ruby-version) for the specific version.
     - Node 19
          - See [`.nvmrc`](.nvmrc) for the specific version.
     - PostgreSQL 14
     - Redis 6.2
     - [Chrome](https://www.google.com/search?q=chrome) (for headless browser tests)

    If you don't have these installed, you can use [rails.new](https://rails.new) to help with the process.

2. Run the `bin/setup` script.
3. Start the application with `bin/dev`.
4. Visit http://localhost:3000.

###  Information about Bullet Train
If this is your first time working on a Bullet Train application, be sure to review the [Bullet Train Basic Techniques](https://bullettrain.co/docs/getting-started) and the [Bullet Train Developer Documentation](https://bullettrain.co/docs).

## Deploying

### Fly.io

Deploy with

```
fly deploy
```

Unfortunately this app does not fit in Fly.io's hobby limits. The web process cannot fit in 512 MB RAM.

If you are using `shared-cpu-1x`, run:

```
fly scale memory 512 --group web
```

You can confirm this worked with `fly scale show`:

```
$ fly scale show
VM Resources for app: polished-dawn-9070

Groups
NAME    COUNT   KIND    CPUS    MEMORY  REGIONS
web     2       shared  1       512 MB  nrt(2)
worker  2       shared  1       256 MB  nrt(2)
```

## Administration

### Restricting registrations

Set the `INVITATION_KEYS` environment variable in either `config/application.yml` or environment variables.

If using Fly.io, run the following:

```
fly secrets set INVITATION_KEYS=comma,delimited,list
```

You can confirm this worked with the following:

```
fly ssh console -C "printenv" | grep INVITATION_KEYS
```
