#' Create the submit file for HTCondor
#'
#' @description
#' This creates the submit file run with \code{condor_submit}. The default arguments take advantage of HTCondor macros to append process id to each output. This has named arguments for usual submit file elements; if you want others, add them to the \code{other} argument in the form you want them in a typical submit file.
#'
#' @param input Input files
#' @param reps Number of replicates to do
#' @param executable Executable file
#' @param arguments Arguments to pass to executable
#' @param log Log file
#' @param output Output file (in addition to ones the script itself creates)
#' @param error Error file
#' @param universe HTCondor universe to use
#' @param requirements  Requirements to pass as a requirements call
#' @param other Other lines to add to the submit file (such as rank)
#' @param submit_file_name Name of the final submit file
#' @examples
#' \dontrun{
#'  submit_file_create(input=c("birds.tre", "bird_traits.csv"), reps=3, executable="batch.R"))
#'}
#' @export
submit_file_create <- function(input, reps=1, executable="run.sh", arguments=NULL, log='log.$(Process)', output='out.$(Process)', error='error.$(Process)', universe="vanilla", requirements=NULL, other=NULL, submit_file_name="Rjob.submit") {
  final.file <- paste0("# Created using htcr at ", Sys.time(), "\n\n")
  final.file <- paste0(final.file, "\nUniverse = ", universe)
  if(!is.null(arguments)) {
    final.file <- paste0(final.file, "\nArguments = ", arguments)
  }
  final.file <- paste0(final.file, "\nInput = ", paste(input, collapse=","))
  final.file <- paste0(final.file, "\nOutput = ", output)
  final.file <- paste0(final.file, "\nLog = ", log)
  final.file <- paste0(final.file, "\nError = ", error)
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
