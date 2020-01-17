# cache directories
set _XDG_DOWNLOAD_DIR (xdg-user-dir DOWNLOAD)

# download
function __dir_is_xdg_download
    [ (pwd) = "$_XDG_DOWNLOAD_DIR" ]
end
