# app.R
library(shiny)

ui <- fluidPage(
  titlePanel("Compound Poisson Process"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("lambda", "Arrival rate λ:", min=0.01, max=5, value=0.5, step=0.01),
      sliderInput("mu", "Jump rate μ:", min=0.01, max=5, value=1.0, step=0.01),
      numericInput("nsim", "Number of simulations:", value=4000, min=100, max=200000),
      checkboxInput("show_theory", "Overlay theoretical pdf", TRUE),
      helpText("Change parameters to update the plots.")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Plots",
                 fluidRow(
                   column(6, plotOutput("plot10", height="300px")),
                   column(6, plotOutput("plot100", height="300px"))
                 ),
                 fluidRow(
                   column(6, plotOutput("plot1000", height="300px")),
                   column(6, plotOutput("plot10000", height="300px"))
                 ),
                 verbatimTextOutput("status")
        ),
        tabPanel("Derivation",
                 withMathJax(
                   div(
                     style = "padding: 15px;",
                     h3("Derivation of the Compound Process"),
                     
                     h4("Definition"),
                     helpText("We study the compound process"),
                     helpText("$$S(t)=\\sum_{i=1}^{N(t)} X_i$$"),
                     helpText("with $$N(t)\\sim\\mathrm{Poisson}(\\lambda t)$$ (exponential interarrival times) and $$X_i\\overset{\\mathrm{iid}}{\\sim}\\mathrm{Exponential}(\\mu).$$"),
                     
                     h4("Laplace transform"),
                     helpText("The Laplace transform is defined as:"),
                     helpText("$$\\mathcal{L}_{S(t)}(u)=E[e^{-uS(t)}].$$"),
                     helpText("Condition on \\(N(t)\\):"),
                     helpText("$$E[e^{-uS(t)}\\mid N(t)=n] = \\big(E[e^{-uX_1}]\\big)^n.$$"),
                     helpText("For an exponential(\\(\\mu\\)) jump:"),
                     helpText("$$E[e^{-uX_1}] = \\frac{\\mu}{\\mu+u}.$$"),
                     helpText("Using the PGF of Poisson, \\(E[s^{N(t)}]=\\exp(\\lambda t (s-1))\\), set \\(s=\\mu/(\\mu+u)\\) to get"),
                     helpText("$$\\boxed{\\;\\mathcal{L}_{S(t)}(u)=\\exp\\Big(-\\lambda t\\frac{u}{\\mu+u}\\Big)\\;.}$$"),
                     
                     h4("Moment Generating Function (MGF)"),
                     helpText("MGF is \\(M_{S(t)}(v)=E[e^{vS(t)}]\\). Relate to Laplace transform by \\(M_{S(t)}(v)=\\mathcal{L}_{S(t)}(-v)\\)."),
                     helpText("Therefore:"),
                     helpText("$$\\boxed{\\;M_{S(t)}(v)=\\exp\\Big(\\lambda t\\frac{v}{\\mu-v}\\Big),\\qquad v<\\mu\\;.}$$"),
                     
                     h4("Mean and Variance"),
                     helpText("From compound-Poisson identities:"),
                     helpText("$$E[S(t)] = E[N(t)]E[X] = \\frac{\\lambda t}{\\mu},$$"),
                     helpText("$$\\mathrm{Var}(S(t)) = \\lambda t\\,E[X^2] = \\frac{2\\lambda t}{\\mu^2}. $$"),
                     
                     h4("At zero and continuous density"),
                     helpText("Point mass at zero:"),
                     helpText("$$P(S(t)=0)=P(N(t)=0)=e^{-\\lambda t}.$$"),
                     helpText("For \\(s>0\\), the continuous pdf (Poisson–Gamma mixture) can be written as"),
                     helpText("$$f_{S(t)}(s)=e^{-\\lambda t-\\mu s}\\sum_{n=1}^\\infty \\frac{(\\lambda t)^n}{n!}\\frac{\\mu^n s^{n-1}}{(n-1)!},\\qquad s>0.$$"),
                     helpText("This series has a closed form using the modified Bessel function:"),
                     helpText("$$\\boxed{\\;f_{S(t)}(s)= e^{-\\lambda t-\\mu s}\\,\\frac{\\lambda t\\,\\mu}{\\sqrt{\\lambda t\\mu s}}\\; I_1\\big(2\\sqrt{\\lambda t\\mu s}\\big),\\quad s>0.\\;}$$"),
                     
                     h4("Normal approximation (large \\(\\lambda t\\))"),
                     helpText("By the CLT, for large \\(\\lambda t\\):"),
                     helpText("$$S(t)\\approx\\mathcal{N}\\Big(\\frac{\\lambda t}{\\mu},\\ \\frac{2\\lambda t}{\\mu^2}\\Big).$$"),
                     
                     h4("Note"),
                     helpText("\\(\\bullet\\) Larger \\(\\lambda\\) increases the expected number of jumps and reduces mass at zero."),
                     helpText("\\(\\bullet\\) Larger \\(\\mu\\) makes jumps smaller (reduces mean and variance)."),
                     helpText("\\(\\bullet\\) For very large \\(\\lambda t\\) use the normal approximation to avoid numerical instability evaluating the Bessel form.")
                   )
                 )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  times <- c(10, 100, 1000, 10000)
  
  simulate_S <- function(lambda, mu, t, n_sims) {
    Ns <- rpois(n_sims, lambda * t)
    sums <- numeric(n_sims)
    maxN <- max(Ns)
    if (maxN > 0) {
      draws <- matrix(rexp(n_sims * maxN, rate=mu), nrow=n_sims, ncol=maxN)
      mask <- t(sapply(Ns, function(n) c(rep(TRUE, n), rep(FALSE, maxN-n))))
      sums <- rowSums(draws * mask)
    }
    sums
  }
  
  f_S <- function(s, lambda, mu, t) {
    # For large lambda*t, bessel expression may be unstable; user can disable overlay if needed.
    a <- lambda * t * mu
    s_pos <- pmax(s, 1e-300)
    exp(-lambda * t - mu*s_pos) * (lambda*t*mu) *
      besselI(2*sqrt(a*s_pos), nu=1) / sqrt(a*s_pos)
  }
  
  sims <- reactive({
    lambda <- input$lambda; mu <- input$mu; nsim <- input$nsim
    # Simulate for each fixed t
    res <- lapply(times, function(t) simulate_S(lambda, mu, t, nsim))
    res
  })
  
  render_hist <- function(idx, t) {
    renderPlot({
      sums <- sims()[[idx]]
      if (length(sums) == 0) return()
      # choose plotting range around the bulk
      xlim_right <- tryCatch(quantile(sums, 0.995), error=function(e) max(sums, na.rm=TRUE))
      hist(sums, breaks=100, freq=FALSE, xlim=c(0, xlim_right),
           main=paste0("t=", t, "  λ=", input$lambda, " μ=", input$mu),
           xlab="S(t)")
      if (input$show_theory) {
        xs <- seq(1e-4, xlim_right, length.out=300)
        # try overlay; if bessel fails, it will produce NA/Inf and not draw
        dens <- f_S(xs, input$lambda, input$mu, t)
        if (all(is.finite(dens))) lines(xs, dens, col="blue", lwd=2)
      }
      mtext(paste0("P(S=0)=", signif(exp(-input$lambda * t), 3)), side=3, line=0.5, adj=0)
    })
  }
  
  output$plot10    <- render_hist(1, 10)
  output$plot100   <- render_hist(2, 100)
  output$plot1000  <- render_hist(3, 1000)
  output$plot10000 <- render_hist(4, 10000)
  
  output$status <- renderPrint({
    cat("Parameters:\n")
    cat(" lambda =", input$lambda, "\n")
    cat(" mu     =", input$mu, "\n")
    cat(" nsim   =", input$nsim, "\n\n")
    cat("Analytic summaries (mean, var):\n")
    for (t in times) {
      cat(" t =", t, ": E[S] =", input$lambda*t/input$mu,
          " Var[S] =", 2*input$lambda*t/input$mu^2, "\n")
    }
  })
}

shinyApp(ui, server)
