#install.packages("shinythemes")
#install.packages("DT")

library(shiny)
library(dplyr)
library(stringr)
library(readr)
library(DT)
library(shinythemes)

# Load the data
music_data <- music::songs

colnames(music_data) <- make.names(colnames(music_data))

vibe_cols <- c("danceability", "energy", "valence", "acousticness",
               "instrumentalness", "liveness", "speechiness", "tempo")

# UI
ui <- fluidPage(
  theme = shinytheme("superhero"),
  tags$head(
    tags$style(HTML("
    body {
      font-family: 'Poppins', sans-serif;
      color: #e3e3e3;
      background-color: #1b1f27;
    }
    .well {
      background-color: #2b303b;
      border: none;
      padding: 15px;
      border-radius: 10px;
    }
    .shiny-input-container {
      margin-bottom: 20px;
    }
    h1.title {
      font-size: 32px;
      color: #fff;
      font-weight: bold;
      margin-top: 10px;
    }
    h4.subtitle {
      color: #aaa;
      margin-bottom: 30px;
      font-weight: normal;
    }
    .song-card {
      background: #2c3e50;
      padding: 15px;
      margin-bottom: 10px;
      border-radius: 10px;
      color: #fff;
      box-shadow: 0px 0px 10px #00000040;
    }
  ")),

    tags$script(HTML("
    $(document).on('keydown', function(e) {
      if (e.key === 'Enter' && $('#song_input').is(':focus')) {
        $('#go').click();
      }
    });
  ")),
    tags$script(HTML("
  $(function () {
    $('[data-toggle=\"tooltip\"]').tooltip();
  });
"))

  ),

  titlePanel(div(
    class = "text-center",
    h1("🎧 Vibe-Based Playlist Generator", class = "title"),
    h4("Discover tracks with similar energy, mood, and danceability", class = "subtitle")
  )),

  sidebarLayout(
    sidebarPanel(
      textInput("song_input", "🔍 Song Title", placeholder = "e.g., Desert Rose"),

      selectInput("genre_filter", "🎼 Genre", choices = c("All", unique(music_data$genre))),

      tags$label("⚡ Energy", `data-toggle` = "tooltip", `data-placement` = "right",
                 title = "Energy: intensity and activity of a track (0 = calm, 1 = intense)"),
      sliderInput("energy_filter", NULL, min = 0, max = 1, value = c(0, 1)),

      tags$label("😊 Valence (Mood)", `data-toggle` = "tooltip", `data-placement` = "right",
                 title = "Valence: musical positivity (0 = sad/serious, 1 = happy/cheerful)"),
      sliderInput("valence_filter", NULL, min = 0, max = 1, value = c(0, 1)),

      tags$label("💃 Danceability", `data-toggle` = "tooltip", `data-placement` = "right",
                 title = "Danceability: how suitable a track is for dancing (0 = least, 1 = most)"),
      sliderInput("dance_filter", NULL, min = 0, max = 1, value = c(0, 1)),

      sliderInput("num_recs", "🔢 Recommendations", min = 5, max = 20, value = 10),

      actionButton("go", "🎶 Generate Playlist", class = "btn btn-primary btn-lg btn-block"),

      downloadButton("download", "⬇️ Download Playlist", class = "btn btn-success")
    ),

    mainPanel(
      uiOutput("playlist_cards")
    )
  )
)

# SERVER
server <- function(input, output, session) {
  results <- reactiveVal()

  observeEvent(input$go, {
    req(input$song_input)
    query <- tolower(str_trim(input$song_input))

    matched_song <- music_data %>%
      mutate(song_lower = tolower(song)) %>%
      filter(str_detect(song_lower, fixed(query))) %>%
      slice_head(n = 1)

    if (nrow(matched_song) == 0) {
      results(data.frame(Message = "No matching song found."))
      return()
    }

    # Apply vibe filters
    filtered <- filter_songs_by_vibe(
      data = music_data,
      energy_range = input$energy_filter,
      valence_range = input$valence_filter,
      dance_range = input$dance_filter,
      genre = input$genre_filter
    )


    # Compute vibe similarity
    song_vec <- matched_song %>% select(all_of(vibe_cols)) %>% as.numeric()
    filtered$distance <- music::compute_vibe_distance(song_vec, filtered, vibe_cols)


    playlist <- filtered %>%
      filter(song != matched_song$song) %>%
      arrange(distance) %>%
      distinct(song, artist, .keep_all = TRUE) %>%
      select(Song = song, Artist = artist, Genre = genre,
             Energy = energy, Valence = valence, Danceability = danceability) %>%
      slice_head(n = input$num_recs)


    results(playlist)
  })

  output$playlist_cards <- renderUI({
    playlist <- results()
    if (is.null(playlist)) return(NULL)
    if ("Message" %in% names(playlist)) {
      return(h4(playlist$Message[1]))
    }

    # Render each result as a stylized card
    lapply(1:nrow(playlist), function(i) {
      song <- playlist[i, ]
      div(class = "song-card",
          tags$strong(song$Song),
          tags$br(),
          paste("Artist:", song$Artist),
          tags$br(),
          paste("Genre:", song$Genre),
          tags$br(),
          paste("Energy:", round(song$Energy, 2)),
          " · ",
          paste("Valence:", round(song$Valence, 2)),
          " · ",
          paste("Danceability:", round(song$Danceability, 2))
      )
    })
  })

  output$download <- downloadHandler(
    filename = function() {
      paste0("vibe_playlist_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write.csv(results(), file, row.names = FALSE)
    }
  )
}

# Run the app
shinyApp(ui = ui, server = server)
