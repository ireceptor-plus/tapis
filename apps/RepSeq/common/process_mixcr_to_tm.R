library(RepSeq)
#library(docstring)
library("argparse")
library('data.table')
source("diversity.R")
source("cdr3length.R")
library(plyr)
library(dplyr)
library(tidyr)
library(tibble)

main<-function(){
  #main function 
  # example from vignette
  parser <- ArgumentParser(description='Process some integers')
  parser$add_argument('directory', type="character",help='file directory')
  parser$add_argument('--output_dir',default="./results/", type="character",help='output directory')
  parser$add_argument('--level', type="character",default="VpJ", dest='level', help='V J VpJ')
  
  # parser$add_argument('--alpha', type="integer", nargs='+',default=c(0, 0.25, 0.5, 1.00001, 2, 4, 8, 16, 32, 64,Inf) ,help='an integer for the accumulator')
  
  args=parser$parse_args()
  try( dir.create(args$output_dir))

  #list file in input folder
  file_list <- list.files(args$directory, full.name = TRUE, pattern = "*.tsv")
  # teff_file_list <- list.files(args$directory, full.name = TRUE, pattern = ".*teff.*.txt")
  process_file(file_list,chain="A",cellType="teff", paste(args$output_dir,"res/",sep=""), args$level,args$directory)
  process_file(file_list,chain="B",cellType="teff",paste(args$output_dir,"res/",sep=""), args$level,args$directory)
  
  # process_file(teff_file_list,chain="A",cellType="teff", paste(args$output_dir,sep=""), args$level,args$directory)
  # process_file(teff_file_list,chain="B",cellType="treg",paste(args$output_dir,sep=""), args$level,args$directory)
}

#' process mixcr file to create sample info and diversity info
#' @param inputFolder folder where mixcr file are stored
#' @param chain alpha or beta chain for TCR (A, B)
#' @param output_dir output directory 
#' @param level level for processing V, J, VpJ, CDR3aa
#' @param inputDir input directory
process_file<-function(inputFolder,cellType, chain, output_dir, level,inputDir){

  datatab <- readClonotypeSet(inputFolder, cores=2L, aligner="MiXCR", chain=chain, sampleinfo=NULL, keep.ambiguous=FALSE, keep.unproductive=FALSE, aa.th=8)
  if(!file.exists(paste(output_dir,"cdr3lenght",chain,".csv", sep=""))){
    # write sample info in a result file
    # lengthFreqDf<-lengthFreq(datatab)
    # lengthFreqDf$lib<-toupper(sub("()(-.*)","",lengthFreqDf$lib))
    # setnames(lengthFreqDf,"lib","id")
    # write.csv(lengthFreqDf,paste(output_dir,"cdr3lenght",cellType,chain,".csv", sep=""),row.names=FALSE)
    
  }else{
    stop(paste("file",output_dir,"cdr3lenght",cellType,chain,".csv"," already exist", sep=""))
  }
  # # write to a file
  if(!file.exists(paste(output_dir,"sample_info",cellType,chain,".csv", sep=""))){
    # write sample info in a result file
    print(output_dir)
    file_name <-paste(output_dir,"sample_info",cellType,chain,".csv", sep="")
    write.csv(datatab@sampleData,file_name)

  }else{
    stop(paste("file",output_dir,"sample_info",cellType,chain,".csv"," already exist", sep=""))
  }
  if(!file.exists(paste(output_dir,"diversity_info",cellType,chain,".csv", sep=""))){
    #diversity info from modified function of repseq package

    basicIndices<-basicIndicesA(datatab, level)
    basicIndices$lib<-toupper(sub("()(-.*)","",basicIndices$lib))
    setnames(basicIndices,"lib","id")
    # rownames(basicIndices)<-basicIndices$id 

  write.csv(basicIndices,paste(output_dir,"diversity_info",cellType,chain,".csv", sep=""),row.names=FALSE)
  length<-datatab@assayData[,.(length=nchar(CDR3dna)),by="CDR3dna"][, mean(length), by="CDR3dna"]
  }else{
    stop(paste("file",output_dir,"diversity_info",cellType,chain,".csv"," already exist", sep=""))

  }
  # # write to a file
  if(!file.exists(paste(output_dir,"renyi_Profile",cellType,chain,".csv", sep=""))){
    res<-renyiProfiles(datatab, level=level)
    res<-t(res)
    d<-as.data.frame(rownames(res))
    colnames(res) <- res[1,]
    res<-cbind(d,res)
    res<-res[-1,]
    setnames(res, "rownames(res)", "id")
    row.names(res) <- NULL

    res$id <- toupper(sub("()(-.*)","", res$id))
    # rownames(res)<-res$id
  write.csv(res,paste(output_dir,"renyi_Profile",cellType,chain,".csv", sep=""),row.names=FALSE)
#  writeReadme(output_dir,inputDir,level,datatab@History$history)
  }else{
    stop(paste("file",output_dir,"renyi_Profile",cellType,chain,".csv"," already exist", sep=""))

  }
  
  writeReadme(output_dir,inputDir,level,datatab@History)
  rm(datatab)
}


#' write a read me for the file
#' @param output_dir output directory 
#' @param inputDir input directory
#' @param level level for processing V, J, VpJ, CDR3aa
#' @param RepseqExperimentHistory a dataframe with the history of a repseq experiment
writeReadme<-function(output_dir, input_dir,level, RepseqExperimentHistory){
  info_file<-paste(output_dir,"info.txt", sep="")
  file.create(info_file)
  
  write("\n",info_file,append =TRUE)
  
  write("----------- commit where the data was generated :-------",info_file,append =TRUE)
  try(write(system("git show --oneline -s", intern = TRUE),info_file,append =TRUE))
  write("----------parameters:---------",info_file,append =TRUE)
  write(paste("input directory :",input_dir,sep=" "),info_file,append =TRUE)
  write(paste("analysis level :",level,sep=" "),info_file,append =TRUE)
  write(paste("output directory :",output_dir,sep=" "),info_file,append =TRUE)
  write("\n",info_file,append =TRUE)
  print("------RepseqExperiment history:--------")
  write("----------RepseqExperiment history:---------",info_file,append =TRUE)
  
  #write(RepseqExperimentHistory,info_file,append =TRUE)

  sessionInfo<-sessionInfo()
  write(sessionInfo$R.version$version.string,info_file,append =TRUE)
  write("\n",info_file,append =TRUE)
  
  write("--------used library---------",info_file,append =TRUE)
  
  sapply(sessionInfo$otherPkgs,function(x)lib_write(x,info_file))
  
}

#' write information in readme file
#' @param package_info information from used package
#' @param file_name file name
lib_write<-function(package_info, file_name){

  write(package_info$Package,file_name,append =TRUE)
  write(package_info$Title,file_name,append =TRUE)
  write(package_info$Version,file_name,append =TRUE)

}

meanLength<-function(repseqExp){
  if (missing(repseqExp)) stop("x is missing.")
  if (!is.RepSeqExperiment(repseqExp)) stop("an object of class RepSeqExperiment is expected.")
}


main()

