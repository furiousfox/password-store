#!/bin/sh

cd ~/.password-store &&
    git ls-tree --name-only -r master | while read FILE
    do
	[ -z "$(git log --after $(date -d "${@}" +%Y-%m-%d) --follow ${FILE})" ] &&
	    echo ${FILE%.*} has expired. &&
	    PLAIN=$(pass show ${FILE%.*}) &&
	    echo ${PLAIN} &&
	    input_cmd(){
		prompt -m "(I)nsert (E)dit (G)enerate (R)m (M)v (C)p (O)verlook (T)ouch" CMD &&
		    case ${CMD} in
			I)
			    pass insert ${FILE%.*} &&
				true
			    ;;
			E)
			    pass edit ${FILE%.*} &&
				true
			    ;;
			G)
			    pass generate --no-symbols ${FILE%.*} ${#PLAIN} &&
				true
			    ;;
			R)
			    pass rm ${FILE%.*} &&
				true
			    ;;
			M)
			    prompt -m "NEW PATH" NEW_PATH &&
				pass mv ${FILE%.*} ${NEW_PATH} &&
				true
			    ;;
			C)
			    prompt -m "NEW PATH" NEW_PATH &&
				pass cp ${FILE%.*} ${NEW_PATH} &&
				true
			O)
			    true
			;;
			T)
			    touch ~/password-store/${FILE} &&
				pass git commit -am "TOUCHED ${FILE%.*} to unexpire." &&
				true
			;;
		    esac &&
		    true
	    done &&
	    true
    done &&
    true
