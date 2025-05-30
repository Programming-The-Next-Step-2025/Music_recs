#' Launch the Vibe-Based Playlist Generator App
#'
#' This function launches the Shiny app for generating music playlists based on song "vibe" similarity.
#'
#' @export
launch_app <- function() {
  app_dir <- system.file("app", package = "music")
  if (app_dir == "") {
    stop("Could not find app directory. Try re-installing the package.", call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}
