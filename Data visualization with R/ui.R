library(shiny)
library(ggplot2)
library(dplyr)


shinyUI(
    navbarPage("Cancer surveys in the ACT ",
               
               tabPanel("INTRODUCTION",
                        fluidPage(
                            column(3),
                            column(6,
                                   div(id="intro-head",
                                       h1("Cancer surveys in the ACT"),
                                       h2("FIT5147 Visualisation Project"),
                                       hr(),
                                       img(id="games-logo", src="https://medicaldialogues.in/h-upload/2020/05/13/128694-cancer.webp")
                                   ),
                                   div(id="intro-text",
                                       br(),
                                       h3("Overview"),
                                       p("This application provides visualisations on data on the Cancer surveys in the ACT, ",
                                         "Data were collected by the ACT Regional Health Department.", 
                                         a("Data Source", href="(https://www.data.act.gov.au/Health/ACT-Selected-Cancer-incidenceandmortality/a2ku-4dqc)"), "."),
                                       p("The project has the following panels:"),
                                       tags$ul(
                                           tags$li(strong("INTRODUCATION"), "- Describe this visualization project in general outlines."),
                                           tags$li(strong("CANCER TREND"), "- Shows the trend in the number of incidences of different cancers between 1985 and 2015."),
                                           tags$li(strong("CANCER PROPORTION"), "- Demonstrates the percentage relationship between different cancers and total cancer incidence between 1985 and 2015."),
                                           tags$li(strong("INCIDENCE VS MORTALITY"), "- The relationship between morbidity and mortality is described for the period 1985-2014."),
                                           tags$li(strong("ONE MORE THING"), "- Describes the regrets of this project.")
                                       ),
                                       
                                   )
                            ),
                            column(3)
                        )
               ),
               
               tabPanel("CANCER TRENDS", 
                        fluidPage(
                            column(3, 
                                   wellPanel(
                                       radioButtons("growthProp", label="Select cancer to view",
                                                    choices=c('All Cancers', 'Bowel Cancer', 'Breast Cancer', 'Lung Cancer','Skin Cancer','Prostate Cancer'), 
                                                    selected='All Cancers'))
                            ),
                            p("_____ for Male"),
                            p("------- for Female"),
                            
                            column(9,
                                   plotOutput("growthPlot", hover=hoverOpts(id="growth.hover")),
                                   hr(),
                                   htmlOutput("yearInfo")
                            )
                        )
               ),
               tabPanel("CANCER PROPORTION",
                        fluidPage(
                          column(3,
                                 wellPanel(
                                   selectInput("YearInput", "Select Year", "All")
                                                )
                                 ),
                          column(9,
                                 plotOutput("piechart")),
                                 
                        
                        div(id="intro-text",
                            p("The meaning of the label:"),
                            tags$ul(
                              tags$li(strong("All sites C00-C96 excl C44"), "- All types of cancer included in the survey. Breast and prostate cancers are not classified separately because they occur in only one sex group."),
                              tags$li(strong("Bowel C18-C20"), "- Showing the percentage of bowel cancer."),
                              tags$li(strong("Lung C33, C34"), "- Showing the percentage of Lung cancer."),
                              tags$li(strong("Melanoma of skin C43"), "- Showing the percentage of Skin Cancer.")
                              
                            ),
                            p(strong("The pie chart shows that stomach, lung and skin cancers are decreasing as a percentage of all cancers."))
                        )
                        )
               ),
               tabPanel("INCIDENCE VS MORTALITY",
                        fluidPage(
                          column(3,
                                 wellPanel(
                                   selectInput("CYearInput", "Select Year", "All"),
                                   selectInput("CancerInput", "Select Cancer", "All")
                                 
                                 )),
                          column(9,
                                 plotOutput("barchart")),
                          
                          
                          div(id="intro-text",
                              p("The meaning of the label:"),
                              tags$ul(
                                tags$li(strong("Incidence: ") ,"- In all cancers, the probability of developing cancer."),
                                tags$li(strong("Mortality: "), "- In all cancers, the probability of death from cancer."),
                                
                                
                              ),
                              p(strong("The Bar chart shows that in recent years, while the number of people with cancer has increased relatively, the death rate from cancer has decreased.")),
                              p("Only part of the data is complete, so only partial data can be compared here.")
                          )
                        )
               ),
               tabPanel("INTRODUCTION",
                        fluidPage(
                          column(3),
                          column(6,
                                 div(id="intro-head",
                                     h1("ONE MORE THING"),
                                    
                                 div(id="intro-text",
                                     br(),
                                     h3("CONCLUSION"),
                                     p("With Data Explortion, we would have liked to study the effects of smoking or drinking on people's cancers. However, due to incomplete data we were unable to get reliable evidence on whether this had an effect or not. The main reasons for this are these:"),
                                     p("REASONS:"),
                                     tags$ul(
                                       tags$li( "A. Men like smoking and drinking more than women, but the ratio of men to women
is almost the same among the heavily dependent smoking and drinking people.
Among people suffering from lung cancer, the number of male patients almost
remains unchanged. It can be speculated that smoking may even more affect 
women's health."),
                                       tags$li( "B.  The original plan of the project was to find, for example, the effect of drinking on
cancers other than stomach cancer. However, it now seems difficult to speculate
about the logical connection. It can hardly be speculated that because the number
of smokers is declining, while the number of drinking alcohol remains basically the
same or increases, perhaps smoking is more harmful to people and can make people
suffer from various cancers."),
                                       tags$li("C. In addition, this project still needs to consider that between 1985 and 2015, the total
population of Australia has increased by nearly 10 million, and modern medicine
has continued to develop over time. These factors may affect the incidence and
mortality of cancer. The fact that the ratio of morbidity to mortality is greatly
reduced may also indicate that people's living conditions or habits have improved.
Of course, these need more research.")
                                       
                                     ),
                                     
                                 )
                          ),
                          column(3)
                        )
               )),
               
               tags$head(
                   tags$link(rel="stylesheet", type="text/css", href="style.css")
               )
               
    ))