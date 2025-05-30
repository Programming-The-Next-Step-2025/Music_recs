#' music: A Vibe-Based Playlist Generator
#'
#' The `music` package allows users to explore songs based on their audio features.
#' It includes an interactive Shiny app that generates playlists similar in mood and energy
#' to a song chosen by the user.
#'
#' @section App Functionality:
#' The package provides a user interface to:
#'
#' - Input a song title and get vibe-based recommendations
#' - Filter results by genre, energy, valence, and danceability
#' - Download the resulting playlist
#'
#' @section Core Functions:
#' - `launch_app()`: Starts the Shiny application
#' - `compute_vibe_distance()`: Computes similarity between songs
#' - `filter_songs_by_vibe()`: Filters candidate songs based on vibe-related criteria
#'
#' @keywords internal
"_PACKAGE"
