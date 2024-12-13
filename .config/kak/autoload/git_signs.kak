# taken from hadronized config: https://git.sr.ht/~hadronized/config/tree/master/item/kak/kakrc

add-highlighter global/git-diff flag-lines Default git_diff_flags

hook global -group git-main-hook BufCreate .* %{
	  # Update git diff column signs
	  try %{ git show-diff }
}

hook global -group git-main-hook FocusIn .* %{
	# Update git diff column signs
	try %{ git update-diff }
}

hook global -group git-main-hook BufReload .* %{
	# Update git diff column signs
	try %{ git update-diff }
}

hook global -group git-main-hook BufWritePost .* %{
	# Update git diff column signs
	try %{ git update-diff }
}
