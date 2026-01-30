kind: manual

sources:
  - kind: git_repo
    url: github:ublue-os/Logomenu.git
    track: main
    ref: ab8b37e524d6795f4eb7170cc62b7f90de7f5729

build-depends:
  - freedesktop-sdk.bst:public-stacks/buildsystem-make.bst
  - freedesktop-sdk.bst:components/jq.bst

depends:
  - freedesktop-sdk.bst:components/gettext.bst
  - gnome-build-meta.bst:sdk/glib.bst
  - gnome-build-meta.bst:core/gnome-shell.bst

variables:
  strip-binaries: ""

config:
  install-commands:
    - |
      _uuid="$(jq -r .uuid metadata.json)"

      glib-compile-schemas --strict schemas/
      install -d "%{install-root}/usr/share/gnome-shell/extensions/${_uuid}"
      cp -R ./* "%{install-root}/usr/share/gnome-shell/extensions/${_uuid}/"
    - |
      %{install-extra}
