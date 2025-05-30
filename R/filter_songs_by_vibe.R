#' Filter Songs by Vibe
#'
#' Filters a dataset of songs based on vibe-related slider input ranges and genre selection.
#'
#' @param data A data frame of songs with vibe features.
#' @param energy_range A numeric vector of length 2 (min, max).
#' @param valence_range A numeric vector of length 2 (min, max).
#' @param dance_range A numeric vector of length 2 (min, max).
#' @param genre Selected genre (or "All").
#'
#' @return A filtered data frame.
#' @export
#'
#' @examples
#' # Load pipe and filter functions
#' library(dplyr)
#'
#' # Create mock data
#' mock_data <- data.frame(
#'   song = c("Song A", "Song B", "Song C"),
#'   artist = c("Artist A", "Artist B", "Artist C"),
#'   genre = c("Pop", "Pop", "Rock"),
#'   energy = c(0.6, 0.9, 0.4),
#'   valence = c(0.7, 0.5, 0.2),
#'   danceability = c(0.8, 0.6, 0.3)
#' )
#'
#' # Filter mock data
#' filtered <- filter_songs_by_vibe(mock_data, c(0.5, 1), c(0.4, 1), c(0.5, 1), "Pop")
#' print(filtered)

filter_songs_by_vibe <- function(data, energy_range, valence_range, dance_range, genre = "All") {
  filtered <- data %>%
    dplyr::filter(
      energy >= energy_range[1], energy <= energy_range[2],
      valence >= valence_range[1], valence <= valence_range[2],
      danceability >= dance_range[1], danceability <= dance_range[2]
    )

  if (genre != "All") {
    filtered <- filtered %>% dplyr::filter(genre == genre)
  }

  return(filtered)
}
