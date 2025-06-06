# Knit Rmd files
lapply(
  list.files(pattern = "*.qmd"),
  function(file) {
    quarto::quarto_render(file, output_format = "all")
  }
)

# Move files to docs/
# Parameters
destination <- "docs"
# Rmd and qmd files
files_source <- c(
  list.files(pattern = "*.Rmd"),
  list.files(pattern = "*.qmd")
)
processed <- NULL
# Create the destination folder (typically "docs/")
if (!dir.exists(destination)) {
  dir.create(destination)
}
# Move output files to clean up the working directory
files_to_move <- c(
  gsub(".[qR]md", ".html", files_source),
  gsub(".[qR]md", ".pdf", files_source),
  gsub(".[qR]md", ".docx", files_source),
  gsub(".[qR]md", ".pptx", files_source)
)
files_to_move <- files_to_move[file.exists(files_to_move)]
if (length(files_to_move) > 0) {
  processed <- c(processed, files_to_move)
  file.rename(
    from = files_to_move,
    to = paste(destination, "/", files_to_move, sep = "")
  )
}
# Copy other necessary files
files_to_copy <- list.files(
  pattern = "*.css"
)
if (length(files_to_copy) > 0) {
  processed <- c(processed, files_to_copy)
  file.copy(
    from = files_to_copy,
    to = paste(destination, "/", files_to_copy, sep = ""),
    overwrite = TRUE
  )
}
# Copy necessary folders
dirs_to_copy <- c(
  # HTML files
  list.files(pattern = "*_files"),
  # images
  list.files(pattern = "images"),
  # R Markdown : libraries
  list.files(pattern = "libs"),
  # Quarto : javascript
  list.files(pattern = "js"),
  # Quarto : css
  list.files(pattern = "css")
)
if (length(dirs_to_copy) > 0) {
  processed <- c(processed, dirs_to_copy)
  vapply(
    dirs_to_copy,
    FUN = file.copy,
    to = destination,
    recursive = TRUE,
    FUN.VALUE = TRUE
  )
}
# Copy README
file.copy(from = "README.md", to = "docs/README.md", overwrite = TRUE)
processed <- c(processed, "README.md")
cat("Output files moved to", destination)
