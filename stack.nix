{ pkgs, ... }:
{
  # The homelab daemon's base module makes this a container, sets the
  # hostname, time zone and stateVersion, and hands in the address. Its host
  # module opens the route's port, gives the immich user and group the ids of
  # the media folder (IMMICH_DATA_DIR) and, with the GPU grant, the host's
  # graphics drivers.

  services.immich = {
    enable = true;
    # Caddy on the host reaches the stack on its private address.
    host = "0.0.0.0";
    port = 2283;
    mediaLocation = "/pool/immich";
    # Hardware transcoding and machine learning on the render node the GPU
    # grant binds in.
    accelerationDevices = [ "/dev/dri/renderD128" ];
    # gunicorn opens a control socket under $HOME, which is /var/empty.
    machine-learning.environment.GUNICORN_CMD_ARGS = "--no-control-socket";
  };

  # Pinned: a new major version needs a dump and restore. The Immich module
  # adds pgvector and vchord and creates the database.
  services.postgresql.package = pkgs.postgresql_17;

  # A dump next to the database: it restores where a copy of a running
  # Postgres data directory may not. The manifest recommends this folder for
  # backup and names the dump unit as its prepare step, so a backup run takes
  # a fresh dump first; the timer keeps one on disk between runs.
  services.postgresqlBackup = {
    enable = true;
    databases = [ "immich" ];
    location = "/var/backup/postgresql";
    compression = "zstd";
    startAt = "*-*-* 02:30:00";
  };
}
