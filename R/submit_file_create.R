#' Create the submit file for HTCondor
#'
#' @description
#' This creates the submit file run with \code{condor_submit}. The default arguments take advantage of HTCondor macros to append process id to each output. This has named arguments for usual submit file elements; if you want others, add them to the \code{other} argument in the form you want them in a typical submit file.
#'
#' @param input Input files
#' @param reps Number of replicates to do
#' @param arguments Arguments to pass to executable
#' @param log Log file
#' @param output Output file (in addition to ones the script itself creates)
#' @param error Error file
#' @param universe HTCondor universe to use
#' @param requirements  Requirements to pass as a requirements call
#' @param other Other lines to add to the submit file (such as rank)
#' @param executable Executable file name to make
#' @param submit_file_name Name of the final submit file
#' @examples
#' \dontrun{
#'  submit_file_create(input=c("birds.tre", "bird_traits.csv"), reps=3, executable="batch.R"))
#'}
#' @export
submit_file_create <- function(input, reps=1, arguments=NULL, log='log.$(Process)', output='out.$(Process)', error='error.$(Process)', universe="vanilla", requirements=NULL, other=NULL, executable="run.sh", submit_file_name="Rjob.submit") {
  final.file <- paste0("# Created using htcr at ", Sys.time(), "\n\n")
  final.file <- paste0(final.file, "\nUniverse = ", universe)
  if(!is.null(arguments)) {
    final.file <- paste0(final.file, "\nArguments = ", arguments)
  }
  final.file <- paste0(final.file, "\ntransfer_input_files = ", paste(input, collapse=",", sep=","))
  final.file <- paste0(final.file, "\nOutput = ", output)
  final.file <- paste0(final.file, "\nLog = ", log)
  final.file <- paste0(final.file, "\nError = ", error)
  final.file <- paste0(final.file, "\nExecutable = ", executable)

  if(!is.null(requirements)) {
      final.file <- paste0(final.file, "\nRequirements = ", requirements)
  }
  if(!is.null(other)) {
      final.file <- paste0(final.file, "\n", other)
  }
  final.file <- paste0(final.file, "\nshould_transfer_files = YES")
  final.file <- paste0(final.file, "\n\nQueue")
  if(reps>1) {
    final.file <- paste0(final.file, " ", reps)
  }
  cat(final.file, file=submit_file_name)
}

#' Create the executable file to run R
#'
#' @description
#' HTCondor needs a simple executable. This will make a file (with the name passed to \code{executable}) that contains a \code{Rscript} command followed by a script name (passed to this function with \code{rscript})
#' @param rscript The R file to run
#' @param executable Executable file name
#' @export
executable_file_create <- function(rscript = "batch.R", executable="run.sh") {
  cat('#!/bin/bash', file=executable, append=FALSE)
  cat("\n", file=executable, append=TRUE)
  cat(paste0("Rscript ", rscript), file=executable, append=TRUE)
}
