library(shiny)

coefficientsRef <- data.frame(gender = c("female","female","female","male","male","male"),
                              race = c("white","black","other","white","black","other"),
                              age = c(-29.799,17.114,-29.799,12.344,2.469,12.344),
                              age2 = c(4.884,NA,4.884,NA,NA,NA),
                              totalCholesterol = c(13.54,0.94,13.54,11.853,0.302,11.853),
                              totalCholesterolAge = c(-3.114,NA,-3.114,-2.664,NA,-2.664),
                              hdl = c(-13.578,-18.92,-13.578,-7.99,-0.307,-7.99),
                              hdlAge = c(3.149,4.475,3.149,1.769,NA,1.769),
                              treatSysBP = c(2.019,29.291,2.019,1.797,1.916,1.797),
                              treatSysBPAge = c(NA,-6.432,NA,NA,NA,NA),
                              NotreatSysBP = c(1.957,27.82,1.957,1.764,1.809,1.764),
                              NotreatSysBPAge = c(NA,-6.087,NA,NA,NA,NA),
                              smoker = c(7.574,0.691,7.574,7.837,0.549,7.837),
                              smokerAge = c(-1.665,NA,-1.665,-1.795,NA,-1.795),
                              diabetes = c(0.661,0.874,0.661,0.658,0.645,0.658),
                              baseMean = c(-29.18,86.61,-29.18,61.18,19.54,61.18),
                              baseSurv = c(0.9665,0.9533,0.9665,0.9144,0.8854,0.9144))

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
