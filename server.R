library(shiny)

coefficientsRef <- read.csv("~/GitHub/riskApp/coefficientsRef.csv")

shinyServer(function(input,output) {

    output$risk <- renderText ({

        coefficients <- coefficientsRef[coefficientsRef$gender %in% input$gender & coefficientsRef$race %in% input$race, 3:17]
        baseMean <- coefficients[, "baseMean"]
        baseSurv <- coefficients[, "baseSurv"]

        pctProfile <- c(log(input$age),
                        log(input$age)^2,
                        log(input$totalCholesterol),
                        log(input$age) * log(input$totalCholesterol),
                        log(input$hdl),
                        log(input$age) * log(input$hdl),
                        log(input$sysBP) * as.numeric(input$treatBP),
                        log(input$age) * log(input$sysBP) * as.numeric(input$treatBP),
                        log(input$sysBP) * as.numeric(!input$treatBP),
                        log(input$age) * log(input$sysBP) * as.numeric(!input$treatBP),
                        as.numeric(input$smoker),
                        log(input$age) * as.numeric(input$smoker),
                        as.numeric(input$diabetes))

        pctSum <- sum(pctProfile * coefficients[, 1:13], na.rm=T)

        paste(round((1 - baseSurv^(exp(pctSum - baseMean))) * 100, 1), "%", "calculeted risk*", sep = " ")
    })

    output$baseline <- renderText ({

        coefficients <- coefficientsRef[coefficientsRef$gender %in% input$gender & coefficientsRef$race %in% input$race, 3:17]
        baseMean <- coefficients[, "baseMean"]
        baseSurv <- coefficients[, "baseSurv"]

        baseProfile <- c(log(input$age),
                         log(input$age)^2,
                         # Total cholesterol = 190 mg/dl
                         log(190),
                         log(input$age) * log(190),
                         # HDL-C = 50 mg/dl
                         log(50),
                         log(input$age) * log(50),
                         # Systolic blood pressure (the two first parameters
                         # apply for those taking anti-hypertensive medications)
                         0,
                         0,
                         # These apply for those not taking anti-hypertensive medications
                         # Baseline systolic blood pressure value is 110 mmHg
                         log(110),
                         log(input$age) * log(110),
                         # The following three parameters are set to "zero",
                         # since the baseline values are FALSE for smoker and diabetes
                         0,
                         0,
                         0)

        baseSum <- sum(baseProfile * coefficients[, 1:13], na.rm=T)

        paste(round((1 - baseSurv^(exp(baseSum - baseMean))) * 100, 1), "%", "with optimal risk factors**", sep = " ")
    })

    output$gender <- renderText({
        paste("Gender: ", toupper(input$gender), sep = " ")
    })
    output$race <- renderText({
        paste("Race: ", toupper(input$race), sep = " ")
    })
    output$age <- renderText({
        paste("Age: ", input$age, "years-old", sep = " ")
    })
    output$totalCholesterol <- renderText({
        paste("Total Cholesterol: ", input$totalCholesterol, "mg/dl", sep = " ")
    })
    output$hdl <- renderText({
        paste("HDL-Cholesterol: ", input$hdl, "mg/dl", sep = " ")
    })
    output$sysBP <- renderText({
        paste("Systolic Blood Pressure: ", input$sysBP, "mmHg", sep = " ")
    })
    output$treatBP <- renderText({
        paste("Hypertension Treatment: ", ifelse(input$treatBP, "YES", "NO"), sep = " ")
    })
    output$smoker <- renderText({
        paste("Smoker: ", ifelse(input$smoker, "YES", "NO"), sep = " ")
    })
    output$diabetes <- renderText({
        paste("Diabetes: ", ifelse(input$diabetes, "YES", "NO"), sep = " ")
    })

})
