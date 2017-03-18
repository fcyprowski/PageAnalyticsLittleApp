library(ggplot2)
plot.theme = theme(axis.text.x = element_text(size = 20, family = "Ubuntu"),
                   axis.title.x = element_blank(),
                   panel.background = element_blank(),
                   plot.background = element_blank())

showLinks = function(data) {
  links = data %>%
    mutate(domain = gsub("http[s]?\\:\\/\\/|www\\.", "", link) %>%
             str_extract("^[a-z]+")) %>%
    group_by(domain) %>%
    dplyr::summarise(median_comments = median(comments_count),
                     how_many_posts = n()) %>%
    arrange(desc(how_many_posts)) %>%
    na.omit()
}
