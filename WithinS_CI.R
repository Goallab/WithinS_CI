WithinS_CI <- function(.data,
                        .subject,
                        .value,
                        .conf = .95,
                        .ws_factors = c(),
                        .bs_factors = c()) { 
  
  # data: Dataframe in long format
  # subject: Name of single column in .data containing participant identifiers
  # value: Name of single column in .data containing values of DV
  # conf: Confidence interval to be calculated
  # ws_factors: names of (multiple) columns in .data containing within-subject factors
  # bs_factors: names of (multiple) columns in .data containing between-subject factors
  
  ### Preparations----
  # Quote all column names handed into function
  .subject <- enquo(.subject)
  .value <- enquo(.value)
  .ws_factors <- enexprs(.ws_factors)
  .bs_factors <- enexprs(.bs_factors)
  .all_grouping <- vars(!!!.bs_factors, !!!.ws_factors) # All within and between factors
  
  # Determine total number of levels for all within subject variables
  .nwithin_levels <- .data %>%
    select(!!!.ws_factors) %>%
    table() %>%
    dim() %>%
    prod()
  
  # Check that no duplicates and, importantly, all within-factors are declared
  .check <- .data %>%
    group_by(!!.subject) %>%
    summarize(n = n())
  if (any(.check$n > .nwithin_levels)) {
    warning("Probably you are not declaring all within-factors or you may have duplicates in your data!")
    return(NULL)
  }

  ### Normalize data----
  # (i.e., get rid of between-subject variance)
  # Exact calculation is dependent on existance of between-subject factors
  if (is_quosure(.bs_factors)) {
    # With between-subject factors
    .norm_data <- .data %>%
      group_by(!!.subject) %>%
      mutate(mean_pp = mean(!!.value)) %>%
      group_by(!!!.bs_factors) %>%
      mutate(grand_mean = mean(!!.value)) %>%
      ungroup() %>%
      mutate(norm_mean = !!.value - mean_pp + grand_mean)
  } else {
    # Without between-subject factors
    .norm_data <- .data %>%
      group_by(!!.subject) %>%
      mutate(mean_pp = mean(!!.value)) %>%
      ungroup() %>%
      mutate(grand_mean = mean(!!.value)) %>%
      mutate(norm_mean = !!.value - mean_pp + grand_mean)
  }
  
  ### Calculate all measures of interest----
  # Calculate correction factor
  # (square root is necessary due to multiplication with sd's instead of variances)
  .correction_factor <- sqrt(.nwithin_levels/(.nwithin_levels - 1))

  # Get sample size, mean and standard deviation for each condition
  .sum_data <- .norm_data %>%
    group_by_at(.all_grouping) %>% # Group by each within and between factor
    summarise(sample_mean = mean(!!.value),
              normalized_mean = mean(norm_mean),
              sample_sd = sd(norm_mean),
              sample_N = n()) %>%
    mutate(corrected_sd = sample_sd * .correction_factor) %>%
    mutate(sample_se = corrected_sd/sqrt(sample_N)) %>%
    mutate(CI_mult = qt(.conf/2 + .5, sample_N - 1)) %>%
    mutate(CI = sample_se * CI_mult)
  
  ### Return output----
  .sum_data
}