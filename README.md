# stack-immich

[Immich](https://immich.app), the self-hosted photo and video library, as a
stack for [homelab-ngx](https://github.com/homelab-ngx/homelab-ngx).

It runs Immich's server and machine learning, PostgreSQL 17 and Redis, built
from nixpkgs. PostgreSQL stays at 17; a later major version needs a dump and
a restore.

## Getting started

1. Add the stack: `homelab stacks add github:homelab-ngx/stack-immich`, or
   Add stack on the dashboard's Stacks page.
2. On the stack's page, press Create on the `IMMICH_DATA_DIR` row. It makes
   the library's folder with the owner Immich needs.
3. Approve the grants and start the stack.
4. Open `https://immich.<your domain>` and create the admin account.
5. For hardware transcoding, choose VA-API or Quick Sync in Immich's video
   settings. Intel and AMD graphics only.

In step 2 you can type the path of a folder you have instead; it keeps its
owner. From a shell, step 2 is
`homelab stacks folder create immich IMMICH_DATA_DIR`.

Create needs homelab-ngx 0.3.1. On an older version, make the folder
yourself and give it an owner nothing else uses.

<!-- manifest:start -->
<!-- Made from homelab-stack.json. Change the manifest, not these lines. -->

## Grants

You approve each of these before the stack starts.

- Route: `immich.<your domain>` to port 2283 in the stack, with requests up to 50GB.
- Storage: the folder in `IMMICH_DATA_DIR`, at `/pool/immich` in the stack, read-write.
- GPU: the render devices of the host, `/dev/dri`.

## Variables

| Name | Kind | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `IMMICH_DATA_DIR` | path | yes |  | Immich's media folder: uploaded originals, the library, thumbnails and encoded video. The stack's immich user and group take its owner and group. |

## Backup

The stack recommends these folders. None is backed up until you add it to a backup.

- Photo library: the folder in `IMMICH_DATA_DIR`.
  - Without `/thumbs/**`. Thumbnails. Immich makes them again from the originals.
  - Without `/encoded-video/**`. Transcoded video. Immich makes it again from the originals.
- Database dump: `/var/backup/postgresql` in the stack.

A backup run starts `postgresqlBackup-immich.service` in the stack and waits for it before it copies.

## Health

An update is kept when all of this holds, and rolled back when it does not.

- `immich-server.service` is active.
- `immich-machine-learning.service` is active.
- `postgresql.service` is active.
- Port 2283 answers at `/api/server/ping`.

Manifest version 8, built with nixpkgs `nixos-unstable`. Runs on [homelab-ngx](https://github.com/homelab-ngx/homelab-ngx).

<!-- manifest:end -->

## License

MIT, see [LICENSE](LICENSE).
