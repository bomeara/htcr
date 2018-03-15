#' Create the submit file for HTCondor
#'
#' @param input Input files
#' @param reps Number of replicates to do
#' @param executable Executable file
#' @param log Log file
#' @param output Output file (in addition to ones the script itself creates)
#' @param error Error file
#' @param universe HTCondor universe to use
#' @param requirements  Requirements to pass as a requirements call
#' @param other Other lines to add to the submit file (such as rank)
#' @param submit_file_name Name of the final submit file
#' @export
submit_file_create <- function(input, reps=1, executable="run.sh", log='log.$(Process)', output='out.$(Process)', error='error.$(Process)', universe="vanilla", requirements=NULL, other=NULL, submit_file_name="Rjob.submit") {
  final.file <- paste0("# Created using htcr at ", Sys.time(), "\n\n")
  final.file <- paste0(final.file, "\nUniverse = ", universe)
  final.file <- paste0(final.file, "\nInput = ", input)
  final.file <- paste0(final.file, "\nOutput = ", output)
  final.file <- paste0(final.file, "\nLog = ", log)
  final.file <- paste0(final.file, "\nError = ", error)
  if(!is.null(requirements)) {
      final.file <- paste0(final.file, "\nRequirements = ", requirements)
  }
  if(!is.null(other)) {
      final.file <- paste0(final.file, "\n", other)
  }
  final.file <- paste0(final.file, "\n\nQueue")
  if(reps>1) {
    final.file <- paste0(final.file, " ", reps)
  }
  cat(final.file, file=submit_file_name)
}
