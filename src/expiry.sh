#!/bin/sh

cd ~/.password-store &&
    for FILE in $(git ls-tree --name-only -r master | grep "[.]gpg\$")
    do
	
	[ -z "$(git log --after $(date -d "${1}" +%Y-%m-%d) --follow ${FILE})" ] &&
	    echo &&
	    echo ${FILE%.*} has expired. &&
	    PLAIN=$(pass show ${FILE%.*}) &&
	    echo ${PLAIN} &&
	    read -p "(I)nsert (E)dit (G)enerate (R)m (M)v (C)p (O)verlook (T)ouch  " CMD &&
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
		    read -p "NEW PATH" NEW_PATH &&
			pass mv ${FILE%.*} ${NEW_PATH} &&
			true
		    ;;
		C)
		    read -p "NEW PATH" NEW_PATH &&
			pass cp ${FILE%.*} ${NEW_PATH} &&
			true
		    ;;
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
