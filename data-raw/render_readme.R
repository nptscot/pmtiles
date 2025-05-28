# This script renders the README.Rmd to README.md

# Ensure the required packages are installed
if (!requireNamespace("rmarkdown", quietly = TRUE)) {
  install.packages("rmarkdown")
}

# Render the README
rmarkdown::render("README.Rmd", output_file = "README.md")

message("README.md has been generated from README.Rmd") 