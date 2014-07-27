library(shiny)

# Define UI for dataset viewer application
shinyUI(fluidPage(theme = "bootstrap.css",

    # Application title
    titlePanel("ASCVD Risk Calculator"),

    sidebarLayout(
        sidebarPanel(

            selectInput(inputId = "gender",
                        label =  "Gender",
                        choices = c("Male" = "male",
                                    "Female" = "female"),
                        selected = "male"),

            selectInput(inputId = "race",
                        label = "Race",
                        choices = c("White" = "white",
                                    "African American" = "black",
                                    "Other" = "other"),
                        selected = "white"),

            numericInput(inputId = "age",
                         label = "Age (years)",
                         min = 20,
                         max = 79,
                         step = 1,
                         value = 55),

            numericInput(inputId = "totalCholesterol",
                         label = "Total Cholesterol (mg/dl)",
                         min = 130,
                         max = 320,
                         step = 1,
                         value = 190),

            numericInput(inputId = "hdl",
                         label = "HDL-C (mg/dl)",
                         min = 20,
                         max = 100,
                         step = 1,
                         value = 50),

            numericInput(inputId = "sysBP",
                         label = "Systolic Blood Pressure (mmHg)",
                         min = 90,
                         max = 200,
                         step = 1,
                         value = 110),

            checkboxInput(inputId = "treatBP",
                          label = "Treatment for Hypertention",
                          value = FALSE),

            checkboxInput(inputId = "smoker",
                          label = "Smoker",
                          value = FALSE),

            checkboxInput(inputId = "diabetes",
                          label = "Diabetes",
                          value = FALSE)
        ),

        mainPanel(
            tabsetPanel(type = "tabs",
                        tabPanel("Risk",
                                 fluidRow(

                                     column(6,
                                            h4("Based on the data entered"),
                                            tags$ul(
                                                tags$li(textOutput("gender")),
                                                tags$li(textOutput("race")),
                                                tags$li(textOutput("age")),
                                                tags$li(textOutput("totalCholesterol")),
                                                tags$li(textOutput("hdl")),
                                                tags$li(textOutput("sysBP")),
                                                tags$li(textOutput("treatBP")),
                                                tags$li(textOutput("smoker")),
                                                tags$li(textOutput("diabetes"))
                                            )
                                     ),

                                     column(6,
                                            h3("10-Years ASCVD Risk"),
                                            verbatimTextOutput("risk"),
                                            verbatimTextOutput("baseline")
                                     )
                                 ),

                                 hr(),

                                 fluidRow(

                                     column(12,
                                            h6(helpText("*Intended for use if there is not ASCVD and the LDL-cholesterol is <190 mg/dL")),
                                            h6(helpText("**Optimal risk factors include: Total cholesterol of 170 mg/dL, HDL-cholesterol of 50 mg/dL, Systolic BP of 110 mm Hg, Not taking medications for hypertension, Not a diabetic, Not a smoker"))
                                     )
                                 )
                        ),

                        tabPanel("About",
                                 h3("About the Application"),

                                 p("The Application was developed as the", strong("Course Project"), "of", em("Developing Data Products by Johns Hopkins University on Coursera.")),
                                 br(),
                                 p("This Risk Calculator enables health care providers and patients to estimate 10-year and lifetime risks for atherosclerotic cardiovascular disease (ASCVD), defined as coronary death or nonfatal myocardial infarction, or fatal or nonfatal stroke, based on the Pooled Cohort Equations and lifetime risk prediction tools. The Risk Estimator is intended for use in those without ASCVD with a LDL-cholesterol <190 mg/dL."),
                                 br(),
                                 p("The information required to estimate ASCVD risk includes age, sex, race, total cholesterol, HDL cholesterol, systolic blood pressure, blood pressure lowering medication use, diabetes status, and smoking status."),
                                 h3("10-Year ASCVD Risk Estimates"),

                                 p("Estimates of 10-year risk for ASCVD are based on data from multiple community-based populations and are applicable to African-American and non-Hispanic white men and women 40 through 79 years of age."),
                                 br(),
                                 p("For other ethnic groups, we recommend use of the equations for non-Hispanic whites, though these estimates may underestimate the risk for persons from some race/ethnic groups.")
                        ),

                        tabPanel("Limitations",
                                 h3("Target Subjects"),

                                 tags$ul(
                                     tags$li(strong("Age: "), "40 - 79 years-old"),
                                     tags$li(strong("Total Cholesterol: "), "130 - 320 mg/dl"),
                                     tags$li(strong("HDL Cholesterol: "), "20 - 100 mg/dl"),
                                     tags$li(strong("Systolic Blood Pressure: "), "90 - 200 mmHg"),
                                     tags$li("Those without ", strong("prior or current ASCVD"))
                                 )
                        ),

                        tabPanel("Disclaimer",
                                 h3("Disclaimer"),

                                 p("The results and recommendations provided by this application are intended to inform but do not replace clinical judgment. Therapeutic options should be individualized and determined after discussion between the patient and their care provider.")
                        ),

                        tabPanel("References",
                                 h3("References"),

                                 tags$ol(
                                     tags$li("2013 ACC/AHA Guideline on the Assessment of Cardiovascular Risk."),
                                     tags$li("2013 ACC/AHA Guideline on the Treatment of Blood Cholesterol to Reduce Atherosclerotic Cardiovascular Risk in Adults."),
                                     tags$li("Expert Panel on Detection, Evaluation, and Treatment of High Blood Cholesterol in Adults. Executive Summary of The Third Report of The National Cholesterol Education Program (NCEP) Expert Panel on Detection, Evaluation, And Treatment of High Blood Cholesterol In Adults (Adult Treatment Panel III). JAMA. 2001 May 16;285(19):2486-97."),
                                     tags$li("Lloyd-Jones DM, Leip EP, Larson MG, et al. Prediction of lifetime risk for cardiovascular disease by risk factor burden at 50 years of age. Circulation. 2006 Feb 14;113(6):791-8. PMID 16461820.")
                                 )
                        )
            )
        ))
))
