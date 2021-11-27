systemctl --user set-environment _JAVA_AWT_WM_NONREPARENTING=1
systemctl --user set-environment MOZ_ENABLE_WAYLAND=1
systemctl --user set-environment MOZ_DBUS_REMOTE=1
systemctl --user set-environment LIBSEAT_BACKEND=logind
systemctl --user set-environment WLR_DRM_DEVICES=/dev/dri/card0
systemctl --user set-environment SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
systemctl --user set-environment DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"

#mehs
systemctl --user set-environment CLUTTER_BACKEND=wayland
systemctl --user set-environment XDG_SESSION_TYPE=wayland
systemctl --user set-environment XDG_CURRENT_DESKTOP=Unity
systemctl --user set-environment QT_QPA_PLATFORM=wayland-egl
systemctl --user set-environment QT_WAYLAND_FORCE_DPI=physical
systemctl --user set-environment QT_WAYLAND_DISABLE_WINDOWDECORATION=1
systemctl --user set-environment SDL_VIDEODRIVER=wayland
systemctl --user set-environment MOZ_WEBRENDER=1
systemctl --user set-environment GOPATH=/home/jbr/.go

export $(systemctl --user show-environment)

systemd-cat -t sway sway
systemctl --user stop sway-session.target
systemctl --user unset-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK
logout
