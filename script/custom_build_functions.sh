function run_cukes {
  if [ -d features ]; then
    echo "${PWD}/bin/cucumber"

    if is_mri_192; then
      # For some reason we get SystemStackError on 1.9.2 when using
      # the bin/cucumber approach below. That approach is faster
      # (as it avoids the bundler tax), so we use it on rubies where we can.
      bundle exec cucumber --strict
    elif is_jruby; then
      return 0
    else
      # Prepare RUBYOPT for scenarios that are shelling out to ruby,
      # and PATH for those that are using `rspec` or `rake`.
      RUBYOPT="${RUBYOPT} -I${PWD}/../bundle -rbundler/setup" \
         PATH="${PWD}/bin:$PATH" \
         bin/cucumber --strict
    fi
  fi
}
