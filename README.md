# openstack-bats

Testing an OpenStack cloud using the OpenStackClient CLI, thanks to bats <https://github.com/bats-core/bats-core>

## How to use

Requirements:

 * `bats` itself
 * `bats-assert` and `bats-support` in `/usr/local/lib/`; otherwise in `test_helper/`
```
test_helper
├── bats-assert
└── bats-support
```
 * `python-openstackclient`
 * `curl`, `jq`, `ping`
 * `clouds.yaml` configuration to authenticate against the OpenStack cloud

Then simply run `bats .` or `bats <specific_file.bats>`, with `OS_CLOUD` environment variable defined pointing to the appropriate `clouds.yaml` configuration.

## Running in a Docker container

A Dockerfile is provided to build an image containing both bats and openstackclient.

```
docker build -t openstack-bats .
```

Running tests within the container can be achieved with:

```
export OS_CLOUD=<cloud>
docker run -it \
  -e OS_CLOUD \
  -v "$HOME/.config/openstack/clouds.yaml:/etc/openstack/clouds.yaml" \
  -v "$PWD:/root/openstack-bats" \
  openstack-bats .
```
