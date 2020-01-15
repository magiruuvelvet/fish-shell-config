# cache directories
set _XDG_DOWNLOAD_DIR (xdg-user-dir DOWNLOAD)

# download
function dir_is_xdg_download
    [ (pwd) = "$_XDG_DOWNLOAD_DIR" ]
end
