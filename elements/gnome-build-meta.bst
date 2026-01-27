kind: junction

sources:
- kind: git_repo
  # url: gnome_gitlab:gnome/gnome-build-meta.git
  # Custom branch with generate-keys support
  # keys: https://gitlab.gnome.org/GNOME/gnome-build-meta/-/merge_requests/4289
  # track: valentindavid/automatically-generate-keys
  # ref: 49-branchpoint-414-g736f7794f272f9d9e4b60e9f3a7f32f40518addf
  url: github:hecknt/gnome-build-meta.git
  track: master
# - kind: patch_queue
#   path: patches/gnome-build-meta

  ref: d5ca3358b9010ea20be296672bdae7fc6431d81d
config:
  overrides:
    # This along with the patches is required and has to match
    # what gnome-build-meta is using
    freedesktop-sdk.bst: freedesktop-sdk.bst

    # Replace the element so the OCI image doesn't have any apps
    core/meta-gnome-core-apps.bst: core/meta-gnome-core-apps.bst

    # Replace the element so the OCI image generates Bluefin's os-release file
    oci/os-release.bst: oci/os-release.bst

    plugins/buildstream-plugins.bst: plugins/buildstream-plugins.bst
    plugins/buildstream-plugins-community.bst: plugins/buildstream-plugins-community.bst
