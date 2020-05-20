function sparkle-update --description="Update apps that use Sparkle framework"
  argparse --name=sparkle-update 'd/directory=' 's/skip=+' -- $argv; or return

  set --local directory $_flag_directory
  if test -z "$directory"
    set directory /Applications
  end

  echo "Checking updates for apps in $directory"

  set --local updates
  for app in (ls $directory)
    if test -d "$directory/$app"; and string match --regex --quiet '.*\.app' $app
      if sparkle $directory/$app --probe 2>/dev/null
        set --append updates $app
      end
    end
  end

  if test (count $updates) -eq 0
    echo 'No updates are available.'
  else
    for update in $updates
      set --local proceed true
      for skip in $_flag_skip
        if test "$skip.app" = "$update"
          set proceed false
          break
        end
      end
      if $proceed
        echo "Updating $update"
        sparkle $directory/$update --check-immediately
      else
        echo "Skipping $update"
      end
    end
    echo 'Finished updating.'
  end
end
