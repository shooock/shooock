library(shiny)
library(ggplot2)
library(dplyr)

#read data
cancer.df <- read.csv(file = "ACT_Selected_Cancer_incidence_and_mortality.csv",
                      head = TRUE, fileEncoding='UTF-8-BOM')
# years
uniqueYears <- as.list(sort(unique(cancer.df$year), decreasing=T)) # decreasing

# cancers
uniquecancer <- as.list(sort(unique(cancer.df$CancerType)))

cancer.colors <- rainbow(6, alpha=NULL)
# color for each CancerType
getCancerColor <- function(df) {
    sapply(df$CancerType, function(CancerType) {
        #cat(file=stderr(), paste0(continent, ' '))
        if (CancerType=='All sites C00-C96 excl C44') { cancer.colors[1] }
        else if (CancerType=='Bowel C18-C20') { cancer.colors[2] }
        else if (CancerType=='Breast C50') { cancer.colors[3] }
        else if (CancerType=='Lung C33, C34') { cancer.colors[4] }
        else if (CancerType=='Melanoma of skin C43') { cancer.colors[5] }
        else if (CancerType=='Prostate C61') { cancer.colors[6] }
        else { 'gray' }
    })
}

# base url for flag images
#flagBaseUrl <- 'http://www.thecgf.com/media/flags/'
# changed to local subdir under www
flagBaseUrl <- 'flags/'

shinyServer(function(input, output, session) {
    
    ###################################
    # numbers of different types of cancers 
    ###################################
    
    cancer_data <- reactive({
        if (input$growthProp=='All Cancers') {
            type<- 'All sites C00-C96 excl C44'
            
            y.name <- 'NumberOfCases'
            subtitle <- 'Number of All Cancers'
            color <- 'red'
            styles <- list(ALL.cANCER=paste0('color:', color, '; font-style:italic'))
        } else if (input$growthProp=='Bowel Cancer') {
            type<- 'Bowel C18-C20'
            
            y.name <- 'NumberOfCases'
            subtitle <- 'Number of Bowel Cncer'
            color <- 'blue'
            styles <- list(Bowel=paste0('color:', color, '; font-style:italic'))
        } else if (input$growthProp=='Breast Cancer') {
            type<- 'Breast C50'
            
            y.name <- 'NumberOfCases'
            subtitle <- 'Number of Breast'
            color <- 'green'
            styles <- list(Breast=paste0('color:', color, '; font-style:italic'))
        } else if(input$growthProp=='Lung Cancer'){
            type<- 'Lung C33, C34'
            
            y.name <- 'NumberOfCases'
            subtitle <- 'Number of Lung'
            color <- 'orange'
            styles <- list(Lung=paste0('color:', color, '; font-style:italic'))
        } else if(input$growthProp=='Skin Cancer'){
            type<- 'Melanoma of skin C43'
            
            y.name <- 'NumberOfCases'
            subtitle <- 'Number of Skin Cancer'
            color <- 'yellow'
            styles <- list(Skin=paste0('color:', color, '; font-style:italic'))
        } else if(input$growthProp=='Prostate Cancer'){
            type<-'Prostate C61'
            
            y.name <- 'NumberOfCases'
            subtitle <- 'Number of Prostate Cancer'
            color <- 'violet'
            styles <- list(Prostate=paste0('color:', color, '; font-style:italic'))
        }
        
        # save to a list
        list(type= type, y.name=y.name, subtitle=subtitle, color=color, styles=styles)
    })
    
    output$growthPlot <- renderPlot({
      df1 <- filter(cancer.df,CancerType == cancer_data()[['type']] & IncidenceMortality_Sex=="Incidence Male")
      df2 <- filter(cancer.df,CancerType == cancer_data()[['type']] & IncidenceMortality_Sex=="Incidence Female")
      
      ggplot()+geom_point(data = df1, aes(x=year, y=NumberOfCases),size=4) +
        geom_line(data = df1, aes(x=year, y=NumberOfCases),color=I(cancer_data()[['color']])) +
        geom_point(data = df2, aes(x=year, y=NumberOfCases),size=4) +
        geom_line(data = df2, aes(x=year, y=NumberOfCases),linetype="dotted",color=I(cancer_data()[['color']]))+
        labs(x='year', y='number',title='CANCERS TREND', subtitle=cancer_data()[['subtitle']]) +
        theme(plot.title=element_text(size=20, hjust=0.5, face="bold")) +
        theme(plot.subtitle=element_text(size=18, hjust=0.5, color=cancer_data()[['color']]))+
        scale_x_continuous(breaks=seq(1985, 2014, by=1)) +
        scale_y_continuous(labels=function(x) { floor(x) })
    })
    output$yearInfo <- renderUI({
      if (!is.null(input$growth.hover)) {
        res <- nearPoints(cancer.df, input$growth.hover, 
                          'year', cancer_data()[['y.name']])
        if (nrow(res) > 0) {
          
          div(id="growth-year-info",
              tags$table(
                tags$tr(tags$td(class="cell-name", "Cancer Type:"), 
                        tags$td(class="cell-value", res$CancerType)),
                tags$tr(tags$td(class="cell-name", "Year:"), 
                        tags$td(class="cell-value", res$year)),
                tags$tr(tags$td(class="cell-name", "Number of Cases: "), 
                        tags$td(class="cell-value", res$NumberOfCases)))
              
          )
          
          
        } else {
          p(class="plot-note", "Hover on a point on the line graph to get more information.")
        }
      } else {
        p(class="plot-note", "Hover on a point on the line graph to get more information.") 
      }
    }) 
    ###################################
    # PIE CHART
    ###################################
    updateSelectInput(session, "YearInput", choices=uniqueYears)
    updateSelectInput(session, "CancerInput", choices=uniquecancer)
    year_data<-reactive({
     cancer.df %>%
        filter(year == input$YearInput,
               IncidenceMortality_Sex=="Incidence Person"
               )
    })
    output$piechart<- renderPlot({
      ggplot(year_data(),aes(x="",y=NumberOfCases,fill=CancerType))+
      geom_bar(stat = "identity", width = 1)+
        coord_polar("y", start = 0)+
        geom_text(aes(label = paste(round(NumberOfCases / sum(NumberOfCases) * 100, 1), "%")),position = position_stack(vjust = 0.5)) +
      theme_classic() +
      theme(plot.title = element_text(hjust=0.5),
            axis.line = element_blank(),
            axis.text = element_blank(),
            axis.ticks = element_blank())+
        labs(x = NULL, y = NULL, title = "Proportion of different Cancers")+
        theme(plot.title=element_text(size=20, hjust=0.5, face="bold"))
    })
    
    ###################################
    # Bar CHART
    ###################################
    updateSelectInput(session, "CYearInput", choices=uniqueYears[-1])
    updateSelectInput(session, "CancerInput", choices=uniquecancer[-c(3,5,6)])
    mi_data<-reactive({
      cancer.df %>%
        filter(year == input$CYearInput,
               CancerType == input$CancerInput,
               sex == 'Person')
    })
    output$barchart<- renderPlot({
      ggplot(mi_data(),aes(x="",y=NumberOfCases,fill=IncidenceMortality))+
        geom_bar(stat = "identity", width = 1)+
        geom_text(aes(label = paste(round(NumberOfCases / sum(NumberOfCases) * 100, 1), "%")),position = position_stack(vjust = 0.5)) +
        theme_classic() +
        theme(plot.title = element_text(hjust=0.5),
              axis.line = element_blank(),
              axis.text = element_blank(),
              axis.ticks = element_blank())+
        labs(x = NULL, y = NULL, title = "Proportion of different Cancers")+
        theme(plot.title=element_text(size=20, hjust=0.5, face="bold"))
    })
})
