
#' compute lots of diversity indices
#' modified from repseq package
#' @param x: Repseqexperiment S4 object
#' @param level: level for computation of diversity
#' @return dataframe of diversity
basicIndicesA <- function(x, level=c("VpJ", "V", "J", "VJ", "CDR3aa")) {
  # function to create all diversity
  
  if (missing(x)) stop("x is missing.")
  if (!is.RepSeqExperiment(x)) stop("an object of class  is expected.")
  levelChoice <- match.arg(level)
  # summary function
  pastek <- function(y) list(shannon=diversityA(y, index="shannon"), simpson=diversityA(y, index="simpson"), berger_parker=diversityA(y, index="berger_parker"),
                             invsimpson=diversityA(y, index="invsimpson"),pielou=diversityA(y, index="pielou"),richness=diversityA(y, index="richness"), gini=gini(y), 
                             chao1=chao1(y)$chao.est, chao1.se=chao1(y)$chao.se, ichao=iChao(y), chaowor=Chaowor(y))   
  out <- assay(x)[, .(count=sum(count)), by=c("lib", levelChoice)][, pastek(count), by="lib"]
  return(out)
}

#'  modified function of repseq package to add other diversity indices
#' compute: simpson, shannon, pielou, richness, gini, berger_parker, invsimpson
#' parameters:
#' @param x: a dataframe of count by sample ( lib)
#' @param index: diversity index to compute   
#' @param norm: boolean to normalise some diversity 
#' @param base: exponential 1 
#' @return the diversity indice needed for a repertoir
diversityA <- function(x, index=c("shannon", "simpson", "invsimpson", "berger_parker", "pielou", "richness"), norm=TRUE, base=exp(1)) {

  
  if (missing(x)) stop("data set x is required.")
  x <- x/sum(x)
  id <- match.arg(index)
  if(id=="berger_parker"){
    # berger parker
    
    H <- -log(max(x))
  }
  if (id == "shannon"|| id=="pielou") {
    x <- -x * log(x, base)
    
  }else if(id=="berger_parker"){
    
  } 
  else {
    x <- x * x
  }
  H <- sum(x, na.rm = TRUE)
  if (id=="pielou"){
    norm=FALSE
    H <-H/log(length(x),base)
  }
  if (norm) H <- H/log(sum(x>0), base)
  if (id == "simpson") {
    H <- 1 - H
  } else if (id == "invsimpson") {
    H <- 1/H
  }
  if (id=="berger_parker"){
    H <- -log(max(x))
  }
  
  if (id=="richness"){
    #richness
    H<-length(x)
  }
  return(H)
}

#' a function from the repseq package not modified
#' @param x an object of class RepSeqExperiment
#' @return gini diversity indice
gini <- function(x) {
  x <- sort(x)
  n <- length(x)
  out <- 1/n * (n + 1 - 2 * sum((n + 1 - 1:n) * x)/sum(x))
  out
}

# compute Chao1 indices
#' a function from the repseq package not modified
# function computes Chao indices
#' @param x an object of class RepSeqExperiment
#' @return a list of chao diversity index
chao1 <- function(x) {
  f1 <- sum(x == 1)
  f2 <- sum(x == 2)
  S <- sum(x > 0)
  #if (f2 > 0) est <- S + f1^2/(2*f2)
  #if (f2 == 0) est <- S + f1*(f1 - 1)/2
  est <- S + f1*(f1 - 1)/(2 * (f2 + 1))
  r <- f1/f2
  chao.var <- f2 * ((r^4)/4 + r^3 + (r^2)/2)
  chao.se <- sqrt(chao.var)
  #return(est)
  return(list(chao.est=est, chao.se=chao.se))
}

#.d50 <- function(x) {
#    
#
#}

#' Improved Chao1
#' a function from the repseq package not modified
#' function computes the improve version of Chao1
#' @param x a vector of count.
#' @return improved Chao1 value (ref) Chao and Lin Chao, A. and Lin, C.-W. (2012) Nonparametric lower bounds for species richness and shared species richness under sampling without replacement. Biometrics,68, 912–921. 
#' @export
# @example
iChao <- function(x) {
  f1 <- sum(x == 1)
  f2 <- sum(x == 2)
  f3 <- sum(x == 3)
  f4 <- sum(x == 4)
  if (f4 == 0) f4 <- 1
  n <- sum(x)
  p1 <- (n-3)/n
  p2 <- (n-3)/(n-1)
  est <- chao1(x)$chao.est + p1*f3/(4*f4) * max(f1 - p2*f2*f3/(2*f4), 0)
  return(est)
}

#' Adjusted Chao1 for sampling without replacement 
#'
#' function compute the correct 
#' @param x a vector of counts
#' @return a value of Chao1
#' @export
# @example
Chaowor <- function(x) {
  f1 <- sum(x == 1)
  f2 <- sum(x == 2)
  S <- sum(x > 0)
  n <- sum(x)
  q <- n/S
  dn1 <- n*2*f2/(n-1)
  dn2 <- q*f1/(q-1)
  est <- S + (f1^2)/(dn1 + dn2)
  return(est)
}