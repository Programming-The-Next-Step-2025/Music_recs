# 🎧 Vibe-Based Playlist Generator

*A Shiny App for Discovering Songs with a Similar Vibe*

## Purpose & Features

**Vibe-Based Playlist Generator** is an R package and Shiny web app that lets users explore songs based on their audio characteristics.

It uses a locally stored dataset of tracks and computes similarity between songs using their audio "vibe" — things like **energy**, **valence**, and **danceability**.

The app helps users find songs that *feel* like a song they already love — without relying on external APIs like Spotify.

------------------------------------------------------------------------

## Main Features

-   **Song Matcher** – Input a song title to find tracks with similar mood and rhythm
-   **Audio Filters** – Filter results based on:
-   Energy (calm → intense)
-   Valence (sad → happy)
-   Danceability (low → high)
-   **Genre Selection** – Narrow results to a specific genre
-   **Downloadable Playlist** – Export your recommendations as a `.csv` file

------------------------------------------------------------------------

## Installation

You can install the development version of the package from GitHub:

``` r
remotes::install_github("Programming-The-Next-Step-2025/Music_recs")
```

## How to Run the App

After installing the package, run:

``` r
library(music)
launch_app()
```

## Core Functions

```         
launch_app() – Starts the Shiny app

compute_vibe_distance() – Computes Euclidean distance between song vectors

filter_songs_by_vibe() – Filters songs by genre and vibe features
```
