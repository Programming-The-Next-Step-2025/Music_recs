#' Compute Vibe Similarity
#'
#' Computes Euclidean distance between a selected song and a set of candidate songs.
#'
#' @param song_vector A numeric vector representing the vibe features of the input song.
#' @param candidates A data frame of candidate songs with vibe features.
#' @param feature_cols Character vector of column names to use for similarity.
#'
#' @return A numeric vector of Euclidean distances, one for each row in `candidates`.
#' @export
#'
#' @examples
#' # Example data
#' song_vector <- c(danceability = 0.7, energy = 0.8, valence = 0.5)
#' candidates <- data.frame(
#'   danceability = c(0.6, 0.9),
#'   energy = c(0.75, 0.85),
#'   valence = c(0.6, 0.4)
#' )
#' feature_cols <- c("danceability", "energy", "valence")
#'
#' compute_vibe_distance(song_vector, candidates, feature_cols)
#' #> Returns numeric distances such as: c(0.122, 0.173)
compute_vibe_distance <- function(song_vector, candidates, feature_cols) {
  apply(candidates[, feature_cols], 1, function(x) {
    sqrt(sum((as.numeric(x) - song_vector)^2))
  })
}
